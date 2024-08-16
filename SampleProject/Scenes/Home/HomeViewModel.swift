//
//  HomeViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import PhotosUI
import LBTATools
import MobilliumBuilders

protocol HomeViewDataSource {}

protocol HomeViewEventSource {}

protocol HomeViewProtocol: HomeViewDataSource, HomeViewEventSource {}

final class HomeViewModel: BaseViewModel<HomeRouter>, HomeViewProtocol {
    
    let imageView = UIImageViewBuilder()
        .image(.headOutline)
        .contentMode(.scaleAspectFit)
        .build()
    
    init(router: HomeRouter) {
        super.init(router: router)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "_UIImagePickerControllerUserDidCaptureItem"), object:nil, queue:nil, using: { [weak self] note in
            self?.imageView.alpha = 0
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "_UIImagePickerControllerUserDidRejectItem"), object: nil, queue: nil) { [weak self] note in
            self?.imageView.alpha = 1
        }

    }
    
    private var phPickerConfiguration: PHPickerConfiguration = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1 // Selection limit. Set to 0 for unlimited.
        config.filter = .images // he types of media that can be get.
        config.preferredAssetRepresentationMode = .current
        return config
    }()
    
    private lazy var documentPickerController: UIDocumentPickerViewController = {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image], asCopy: true)
        picker.allowsMultipleSelection = false
        picker.delegate = self
        return picker
    }()
    
    private var cameraImagePicker: UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = UIDevice.current.userInterfaceIdiom == .pad ? .rear : .front
        imagePicker.mediaTypes = ["public.image"] // Sadece resim dosyalarını seçmek için
        
        imageView.withWidth(ScreenSize.width)
        imagePicker.view.addSubview(imageView)
        imageView.center(in: imagePicker.view)
        
        return imagePicker
    }


}

extension UIImagePickerController {
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.subviews.forEach { view in
            view.alpha = 1
        }
    }
}

//MARK: - Actions
extension HomeViewModel {
    func didTapPickPhotoFromGallery() {
        router.presentPhotoPicker(config: phPickerConfiguration, parent: self)
    }
    
    func didTapPickPhotoFromCloud() {
        router.viewController?.present(documentPickerController, animated: true)
    }
    
    func didTapTakePhoto() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                DispatchQueue.main.async {self.router.viewController?.present(self.cameraImagePicker, animated: true)}
            } else {
                DispatchQueue.main.async {
                    AppRouter.shared.topViewController()?.showAlertWithTwoActions(
                        title: "Camera Unavailable",
                        message: "You need to go to Settings and allow access to Camera to use this feature.",
                        action1Title: "OK",
                        action2Title: "Settings",
                        action2Handler: { _ in
                        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                        }
                    },
                        onlyGreat: false
                    )
                }
            }
        }
    }
}

//MARK: - UIImagePickerControllerDelegate
extension HomeViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        router.presentProcessing()
        if let image = info[.originalImage] as? UIImage {
            if let result = image.removeBackground(returnResult: .finalImage) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closeProcessing.send(())
                    self.router.pushEdit(image: result)
                }
            } else {
                ToastPresenter.showWarningToast(text: "An error occurred while removing the background.")
                closeProcessing.send(())
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}


//MARK: - PHPickerViewControllerDelegate
extension HomeViewModel: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }
        
        picker.dismiss(animated: true)
        self.router.presentProcessing()
        
        let itemProviders = results.map { $0.itemProvider }
        itemProviders.forEach { item in
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if let removed = image.removeBackground(returnResult: .finalImage) {
                                closeProcessing.send(())
                                self.router.pushEdit(image: removed )
                            } else {
                                ToastPresenter.showWarningToast(text: "An error occurred while removing the background.")
                                closeProcessing.send(())
                            }
                        }
                    }
                }
            }
        }
    }
        
}

import Kingfisher

//MARK: - UIDocumentPickerDelegate
extension HomeViewModel: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        if urls.isEmpty {
            controller.dismiss(animated: true)
            return
        }
        
        DispatchQueue.main.async {
            controller.dismiss(animated: true)
            self.router.presentProcessing()
        }

        do {
            let image = UIImage(data: try Data(contentsOf: urls.first!)) ?? UIImage()
            if let removed = image.removeBackground(returnResult: .finalImage) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closeProcessing.send(())
                    self.router.pushEdit(image: removed )
                }
            } else {
                ToastPresenter.showWarningToast(text: "An error occurred while removing the background.")
                closeProcessing.send(())
            }
            
        } catch {}
        
    }
}
