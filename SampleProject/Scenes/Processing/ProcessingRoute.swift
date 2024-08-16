//
//  ProcessingRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

protocol ProcessingRoute {
    func presentProcessing()
}

extension ProcessingRoute where Self: RouterProtocol {
    
    func presentProcessing() {
        let router = ProcessingRouter()
        let viewModel = ProcessingViewModel(router: router)
        let viewController = ProcessingViewController(viewModel: viewModel)
        
        let transition = ModalTransition(animator: .none, isAnimated: false, modalTransitionStyle: .crossDissolve, modalPresentationStyle: .fullScreen)
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}
