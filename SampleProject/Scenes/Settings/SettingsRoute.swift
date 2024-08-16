//
//  SettingsRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

protocol SettingsRoute {
    func pushSettings()
}

extension SettingsRoute where Self: RouterProtocol {
    
    func pushSettings() {
        let router = SettingsRouter()
        let viewModel = SettingsViewModel(router: router)
        let viewController = SettingsViewController(viewModel: viewModel)
        viewController.title = L10n.Screens.Settings.title
        
        let transition = PushTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}
