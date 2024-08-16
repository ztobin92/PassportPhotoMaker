//
//  SettingsRouter.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

final class SettingsRouter: Router, SettingsRouter.Routes {
    typealias Routes = PresentSafariRoute & ShareSheetRoute & MailRoute & PaywallRoute & ChangeLanguageRoute
}
