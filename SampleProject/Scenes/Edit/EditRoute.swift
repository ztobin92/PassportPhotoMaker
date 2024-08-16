//
//  EditRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 16.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//
import UIKit

protocol EditRoute {
    func pushEdit(image: UIImage)
}

extension EditRoute where Self: RouterProtocol {
    
    func pushEdit(image: UIImage) {
        let router = EditRouter()
        let viewModel = EditViewModel(image: image, router: router)
        let viewController = EditViewController(viewModel: viewModel)
        viewController.title = L10n.Screens.Edit.title
        
        let transition = PushTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}
