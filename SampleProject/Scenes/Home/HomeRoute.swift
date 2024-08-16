//
//  HomeRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

protocol HomeRoute {
    func presentHome()
}

extension HomeRoute where Self: RouterProtocol {
    
    func presentHome() {
        let router = HomeRouter()
        let viewModel = HomeViewModel(router: router)
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.title = "Passport Photo"
        let nav = MainNavigationController(rootViewController: viewController)
        
        let transition = PlaceOnWindowTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        open(nav, transition: transition)
    }
}
