//
//  CameraViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var shapeLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Kamera önizlemesini görüntüleyecek bir view oluşturun
        let previewView = UIView(frame: view.bounds)
        view.addSubview(previewView)
        
        // AVCaptureSession örneğini oluşturun
        captureSession = AVCaptureSession()
        
        // Kamerayı temsil eden bir AVCaptureDevice örneği alın
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            // AVCaptureDeviceInput örneğini oluşturun
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // AVCaptureSession'a input'u ekle
            captureSession?.addInput(input)
            
            // AVCaptureVideoPreviewLayer örneğini oluşturun ve previewView'a ekle
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = previewView.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            // Yardımcı çizim için CAShapeLayer örneğini oluşturun
            shapeLayer = CAShapeLayer()
            shapeLayer?.strokeColor = UIColor.red.cgColor
            shapeLayer?.lineWidth = 2.0
            shapeLayer?.fillColor = UIColor.clear.cgColor
            previewView.layer.addSublayer(shapeLayer!)
            
            // AVCaptureSession'u başlat
            captureSession?.startRunning()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension CameraViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Yardımcı çizimi konumlandırma
        if let videoPreviewLayer = videoPreviewLayer {
            shapeLayer?.frame = videoPreviewLayer.frame
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else { return }
        
        // Yardımcı çizimi güncelleme
        let path = UIBezierPath(rect: CGRect(x: touchPoint.x - 50, y: touchPoint.y - 50, width: 100, height: 100))
        shapeLayer?.path = path.cgPath
    }
}
