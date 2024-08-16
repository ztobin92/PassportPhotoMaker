//
//  ExportRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 19.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

protocol ExportRoute {
    func presentExport(image: UIImage, ratio: CGFloat, bgColor: UIColor)
}

extension ExportRoute where Self: RouterProtocol {
    
    func presentExport(image: UIImage, ratio: CGFloat, bgColor: UIColor) {
        let router = ExportRouter()
        let viewModel = ExportViewModel(image: image,ratio: ratio,bgColor: bgColor, router: router)
        let viewController = ExportViewController(viewModel: viewModel)
        let nav = MainNavigationController(rootViewController: viewController)
        
        let transition = ModalTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        open(nav, transition: transition)
    }
}
