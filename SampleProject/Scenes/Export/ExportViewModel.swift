//
//  ExportViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 19.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import LBTATools

protocol ExportViewDataSource {
    var image: UIImage {get}
}

protocol ExportViewEventSource {}

protocol ExportViewProtocol: ExportViewDataSource, ExportViewEventSource {}

final class ExportViewModel: BaseViewModel<ExportRouter>, ExportViewProtocol {
    var image: UIImage
    var ratio: CGFloat
    var bgColor: UIColor
    
    init(image: UIImage,ratio: CGFloat, bgColor: UIColor, router: ExportRouter) {
        self.image = image
        self.ratio = ratio
        self.bgColor = bgColor
        super.init(router: router)
    }
    
    func didTapShare(image: UIImage) {
        let ref = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).jpg")
        
        do {
            let data = image.jpegData(compressionQuality: 1)
            try data?.write(to: ref)
            router.presentShareSheet(items: [ref], withRate: true)
        } catch  {}
    }
    
    func didTapDownload(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        RatingHelper.shared.increaseLikeCountAndShowRatePopup(for: .download)
    }
    
    func didTapPrint(image: UIImage) {
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .general
        printInfo.orientation = .portrait // Ya da .landscape kullanarak yönlendirmeyi ayarlayabilirsiniz

        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("image.png")
        
        let printSize = lastSize.value
        
        do {
            try image.pngData()?.write(to: url)
            let printFormatter = UIMarkupTextPrintFormatter(markupText: "<html><body><img src=\"\(url.absoluteString)\" style=\"width:\(printSize.width)\(lastMetric.value.ID); height:\(printSize.height)\(lastMetric.value.ID);\"></body></html>")
            printController.printFormatter = printFormatter

        } catch  { }
        
        printController.present(animated: true, completionHandler: { _, _, _ in
            RatingHelper.shared.increaseLikeCountAndShowRatePopup(for: .print)
        })
    }
}

func cropImage(image: UIImage, rect: CGRect) -> UIImage? {
    let cgImage = image.cgImage!
    let croppedCGImage = cgImage.cropping(to: rect)
    if let croppedImage = croppedCGImage {
        return UIImage(cgImage: croppedImage)
    }
    return nil
}
