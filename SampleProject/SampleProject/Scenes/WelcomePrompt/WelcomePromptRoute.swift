//
//  WelcomePromptRoute.swift
//  NewWatchFacesApp
//
//  Created by Bora Erdem on 22.05.2023.
//

protocol WelcomePromptRoute {
    func presentWelcomePrompt()
}

extension WelcomePromptRoute where Self: RouterProtocol {
    
    func presentWelcomePrompt() {
        let router = WelcomePromptRouter()
        let viewModel = WelcomePromptViewModel(router: router)
        let viewController = WelcomePromptViewController(viewModel: viewModel)
        
        let transition = ModalTransition(isAnimated: true, modalTransitionStyle: .crossDissolve, modalPresentationStyle: .fullScreen)
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}
