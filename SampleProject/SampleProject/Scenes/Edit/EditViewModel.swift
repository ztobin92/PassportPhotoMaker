//
//  EditViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 16.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import UIKit
import Combine

protocol EditViewDataSource {
    var image: UIImage {get}
    var selectedButton: CurrentValueSubject<String, Never> {get}

}

protocol EditViewEventSource {}

protocol EditViewProtocol: EditViewDataSource, EditViewEventSource {}

final class EditViewModel: BaseViewModel<EditRouter>, EditViewProtocol {
    var image: UIImage
    var selectedButton = CurrentValueSubject<String, Never>(L10n.Screens.Edit.color)
    var updateImageBGColor: ((UIColor)->())?
    
    var instructions: [String] = [
        L10n.Screens.Edit.Instructions._1,
        L10n.Screens.Edit.Instructions._2,
        L10n.Screens.Edit.Instructions._3
    ]
    
    init(image: UIImage, router: EditRouter) {
        self.image = image
        super.init(router: router)
    }
    
    var filters: [Filter] = [
        Filter(title: "None", filterID: "none"),
        Filter(title: "Sepia", filterID: "CISepiaTone"),
        Filter(title: "Chrome", filterID: "CIPhotoEffectChrome"),
        Filter(title: "Fade", filterID: "CIPhotoEffectFade"),
        Filter(title: "Instant", filterID: "CIPhotoEffectInstant"),
        Filter(title: "Mono", filterID: "CIPhotoEffectMono"),
        Filter(title: "Noir", filterID: "CIPhotoEffectNoir"),
        Filter(title: "Process", filterID: "CIPhotoEffectProcess"),
        Filter(title: "Tonal", filterID: "CIPhotoEffectTonal"),
        Filter(title: "Transfer", filterID: "CIPhotoEffectTransfer"),
        Filter(title:  "Vignette", filterID: "CIVignette")
    ]
    
    let sizes = ["2x2","2x2.5","2x3","1.3x1.9", "1.5x1.5","1.5x2","1.5x2.5", "2x3.5","2.5x3.5", "3x4", "3.5x5", "4x4.5"]
    
    let colors: [UIColor] = [
        .init(hexString: "FFFFFF"),
        .init(hexString: "F2F2F2"),
        .init(hexString: "E5E5E5"),
        .init(hexString: "333333"),
        .init(hexString: "FFC0CB"),
        .init(hexString: "FFA07A"),
        .init(hexString: "D8D8D8"),
        .init(hexString: "CCCCCC"),
        .init(hexString: "BFBFBF"),
        .init(hexString: "B2B2B2"),
        .init(hexString: "A5A5A5"),
        .init(hexString: "999999"),
        .init(hexString: "8C8C8C"),
        .init(hexString: "808080"),
        .init(hexString: "737373"),
        .init(hexString: "666666"),
        .init(hexString: "595959"),
        .init(hexString: "4C4C4C"),
        .init(hexString: "3F3F3F"),
        .init(hexString: "FF7F50"),
        .init(hexString: "FF4500"),
        .init(hexString: "FFD700"),
        .init(hexString: "FFA500"),
        .init(hexString: "FF6347"),
        .init(hexString: "FF0000"),
        .init(hexString: "DC143C"),
        .init(hexString: "B22222"),
        .init(hexString: "8B0000"),
        .init(hexString: "800000"),
    ]
    
    func didTapGoColorPicker() {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        router.viewController?.present(picker, animated: true)
    }
}

extension EditViewModel: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        viewController.dismiss(animated: true)
        updateImageBGColor?(viewController.selectedColor )
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        updateImageBGColor?(viewController.selectedColor )
    }
}
