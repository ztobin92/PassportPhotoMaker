//
//  PhotoPickerRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import PhotosUI

protocol PhotoPickerRoute {
    func presentPhotoPicker(config : PHPickerConfiguration, parent: PHPickerViewControllerDelegate)
}

extension PhotoPickerRoute where Self: RouterProtocol {
    
    func presentPhotoPicker(config : PHPickerConfiguration, parent: PHPickerViewControllerDelegate) {
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = parent
        let transition = ModalTransition(animator: .none, isAnimated: true, modalTransitionStyle: .coverVertical, modalPresentationStyle: .formSheet)
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .denied:
                DispatchQueue.main.async {
                    AppRouter.shared.topViewController()?.showAlertWithTwoActions(
                        title: "Gallery Unavailable!",
                        message: "You need to go to Settings and allow access to Gallery to use this feature.",
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
            case .authorized:
                DispatchQueue.main.async {
                    self.open(picker, transition: transition)
                }
            default:
                break;
            }
        }
    }
}
