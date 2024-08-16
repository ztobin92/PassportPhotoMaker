//
//  SettingsViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import StoreKit
import Defaults
import MessageUI

protocol SettingsViewDataSource {
    func numberOfItemsAt(section: Int) -> Int
    func cellItemAt(indexPath: IndexPath) -> SettingsCellProtocol
}

protocol SettingsViewEventSource {}

protocol SettingsViewProtocol: SettingsViewDataSource, SettingsViewEventSource {}

final class SettingsViewModel: BaseViewModel<SettingsRouter>, SettingsViewProtocol {
    
    var reloadData: VoidClosure?
    
    func numberOfItemsAt(section: Int) -> Int {
        return cellItems[section].count
    }
    
    func numberOfSections() -> Int {
        return cellItems.count
    }
    
    func cellItemAt(indexPath: IndexPath) -> SettingsCellProtocol {
        return cellItems[indexPath.section][indexPath.row]
    }
    
    private var cellItems: [[SettingsCellProtocol]] = []
    
    func configureItems() {
        cellItems = [
            [
                SettingsCellModel(image: .heartIcon, title: 
                                    L10n.Screens.Settings.rate, action: didTapRate)
            ],
            [
                SettingsCellModel(image: .shareIcon, title: L10n.Screens.Settings.share, action: didTapShareUs),
                SettingsCellModel(image: .mailIcon, title: L10n.Screens.Settings.contact, action: didTapSupport),
                SettingsCellModel(image: .init(systemName: "globe")!, title: L10n.Screens.Language.title, action: didTapLanguage)
            ],
            [
                SettingsCellModel(image: .paperIcon, title: L10n.Screens.privacy, action: didTapPrivacy),
                SettingsCellModel(image: .paperIcon, title: L10n.Screens.terms, action: didTapTerms),
            ],
        ]
        
        if !Defaults[.premium] {
            cellItems.insert([SettingsCellModel(image: .init(systemName: "crown")!, title: L10n.Screens.Settings.unlock, action: didTapGoPaywall)], at: 0)
        }
        
        reloadData?()
    }
}

extension SettingsViewModel {
    func didTapPrivacy() {
        router.presentInSafari(with: .init(string: "https://docs.google.com/document/d/1yPIs6XCaIp9BSWKNsytYm6g15iG2Sm-78mPftSEpXWc")!)
    }
    
    func didTapTerms() {
        router.presentInSafari(with: .init(string: "https://docs.google.com/document/d/1IcZGaXCb3YNdYWd0p0xD2YFY6iFiAnRAruQZlQKvwV0")!)
    }
    
    func didTapGoPaywall() {
        router.presentPaywall()
    }

    func didTapLanguage() {
        router.pushChangeLanguage()
    }
    
    func didTapRate() {
        if Defaults[.totalRatingAskCount] == 0 {
            guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id6449979104?action=write-review")
                    else { return }
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        } else {
            SKStoreReviewController.requestReviewInCurrentScene()
        }
    }
    
    func didTapShareUs() {
        router.presentShareSheet(items: [URL(string: "https://apps.apple.com/us/app/us-passport-photo-maker-aid/id6449979104")!])
    }
    
    func didTapSupport() {
        if MFMailComposeViewController.canSendMail() {
            router.sendMailSheet(composer: MailHelper.shared.prepareComposer())
            return
        }
        
        if let emailUrl = MailHelper.shared.createEmailUrl(to: "hi@appelio.com", subject: "", body: "") {
            UIApplication.shared.open(emailUrl)
        }
    }
}
