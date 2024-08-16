//
//  HomeRouter.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

final class HomeRouter: Router, HomeRouter.Routes  {
    typealias Routes = SettingsRoute & PhotoPickerRoute & ProcessingRoute & EditRoute & WelcomePromptRoute & PaywallRoute
}
