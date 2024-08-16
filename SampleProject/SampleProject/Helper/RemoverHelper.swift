//
//  RemoverHelper.swift
//  SampleProject
//
//  Created by Bora Erdem on 16.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation

import UIKit
import CoreML
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins
import VideoToolbox

enum RemoveBackroundResult {
    case background
    case finalImage
}

extension UIImage {

    func removeBackground(returnResult: RemoveBackroundResult) -> UIImage? {
        if #available(iOS 15.0, *) {
            let image = runVisionRequest(inputImage: self)
            return image
        } else {
            guard let model = getDeepLabV3Model() else { return nil }
            let width: CGFloat = 513
            let height: CGFloat = 513
            let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
            guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
                  let outputPredictionImage = try? model.prediction(image: pixelBuffer),
                  let outputImage = outputPredictionImage.semanticPredictions.image(min: 0, max: 1, axes: (0, 0, 1)),
                  let outputCIImage = CIImage(image: outputImage),
                  let maskImage = outputCIImage.removeWhitePixels(),
                  let maskBlurImage = maskImage.applyBlurEffect() else { return nil }
            
            switch returnResult {
            case .finalImage:
                guard let resizedCIImage = CIImage(image: resizedImage),
                      let compositedImage = resizedCIImage.composite(with: maskBlurImage) else { return nil }
                let finalImage = UIImage(ciImage: compositedImage)
                    .resized(to: CGSize(width: size.width, height: size.height))
                return finalImage
            case .background:
                let finalImage = UIImage(
                    ciImage: maskBlurImage,
                    scale: scale,
                    orientation: self.imageOrientation
                ).resized(to: CGSize(width: size.width, height: size.height))
                return finalImage
            }
        }
    }

    private func getDeepLabV3Model() -> DeepLabV3? {
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .all
            return try DeepLabV3(configuration: config)
        } catch {
            return nil
        }
    }

}

extension CIImage {

    func removeWhitePixels() -> CIImage? {
        let chromaCIFilter = chromaKeyFilter()
        chromaCIFilter?.setValue(self, forKey: kCIInputImageKey)
        return chromaCIFilter?.outputImage
    }

    func composite(with mask: CIImage) -> CIImage? {
        return CIFilter(
            name: "CISourceOutCompositing",
            parameters: [
                kCIInputImageKey: self,
                kCIInputBackgroundImageKey: mask
            ]
        )?.outputImage
    }

    func applyBlurEffect() -> CIImage? {
        let context = CIContext(options: nil)
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        clampFilter.setDefaults()
        clampFilter.setValue(self, forKey: kCIInputImageKey)

        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        currentFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        currentFilter.setValue(1, forKey: "inputRadius")
        guard let output = currentFilter.outputImage,
              let cgimg = context.createCGImage(output, from: extent) else { return nil }

        return CIImage(cgImage: cgimg)
    }

    // modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
    private func chromaKeyFilter() -> CIFilter? {
        let size = 64
        var cubeRGB = [Float]()

        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size - 1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size - 1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size - 1)
                    let brightness = getBrightness(red: red, green: green, blue: blue)
                    let alpha: CGFloat = brightness == 1 ? 0 : 1
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }

        let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))

        let colorCubeFilter = CIFilter(
            name: "CIColorCube",
            parameters: [
                "inputCubeDimension": size,
                "inputCubeData": data
            ]
        )
        return colorCubeFilter
    }

    // modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
    private func getBrightness(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        var brightness: CGFloat = 0
        color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
}

func runVisionRequest(inputImage: UIImage) -> UIImage? {
    
    if #available(iOS 15.0, *) {
        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: inputImage.cgImage!, options: [:])
        
        do {
            try handler.perform([request])
            
            let mask = request.results!.first!
            let maskBuffer = mask.pixelBuffer
            
             return maskInputImage(inputImage: inputImage, maskBuffer)
            
        }catch {
            return nil
        }

    } else {
        return nil
    }
}

func maskInputImage(inputImage: UIImage, _ buffer: CVPixelBuffer) -> UIImage? {
    
    let input = CIImage(cgImage: inputImage.cgImage!)
    let mask = CIImage(cvPixelBuffer: buffer)
    
    
    let maskScaleX = input.extent.width / mask.extent.width
    let maskScaleY = input.extent.height / mask.extent.height
    
    let maskScaled =  mask.transformed(by: __CGAffineTransformMake(maskScaleX, 0, 0, maskScaleY, 0, 0))
    
    let blendFilter = CIFilter.blendWithMask()
    
    blendFilter.inputImage = input
    blendFilter.maskImage = maskScaled

    if let blendedImage = blendFilter.outputImage{
    
        let ciContext = CIContext(options: nil)
        let filteredImageRef = ciContext.createCGImage(blendedImage, from: blendedImage.extent)
        let maskDisplayRef = ciContext.createCGImage(maskScaled, from: maskScaled.extent)
        
        var orientation: UIImage.Orientation = .up
        var result = UIImage(cgImage: filteredImageRef!)
        orientation = result.size.width > result.size.height ? .right : .up
        
        let rotatedImage = UIImage(cgImage: filteredImageRef!, scale: inputImage.scale, orientation: orientation)

        return rotatedImage
    }
    
    return nil
}
