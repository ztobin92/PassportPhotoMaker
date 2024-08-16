//
//  AppDelegate.swift
//  SampleProject
//
//  Created by Mehmet Salih Aslan on 3.11.2020.
//  Copyright © 2020 Mobillium. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import Qonversion
import UIComponents
import Defaults
import Localize_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureIQKeyboardManager()
        configureSKPhotoBrowser()
        
        let config = Qonversion.Configuration(projectKey: "WqfuYvefcrT1XgDYZdhULrF1dnPxwLs3", launchMode: .subscriptionManagement)
        Qonversion.initWithConfig(config)
        RevenueHelper.shared.fetchProdutcs()
        Qonversion.shared().collectAppleSearchAdsAttribution()
        configureLanguage()
        
        FirebaseApp.configure()
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        self.window?.makeKeyAndVisible()
        AppRouter.shared.startApp()
        return true
    }
    
        public func configureLanguage() {
            LocalizableManager.observe()
            if Localize.availableLanguages().contains(Localize.currentLanguage()) {
                Localize.setCurrentLanguage(Localize.currentLanguage())
                LocalizableManager.globalLocalize.send(Localize.currentLanguage())
            }
            
            if let usersLang = Defaults[.prefferedLanguage] {
                Localize.setCurrentLanguage(usersLang)
                LocalizableManager.globalLocalize.send(usersLang)
            }
            
            print(Localize.currentLanguage())
        }

}
