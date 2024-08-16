//
//  RatingHelper.swift
//  SampleProject
//
//  Created by Bora Erdem on 19.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import Defaults
import StoreKit

var askCount = 0

public final class RatingHelper {
    public static let shared = RatingHelper()
    
    public func increaseLikeCountAndShowRatePopup(for alert: AlertType) {
        Defaults[.totalRatingAskCount] += 1
        if self.ratingPromptCounterLogic() {
            askCount += 1
            alert == .welcome ? self.showWelcomeAlert() : self.prepareCustomRatePopup(for: alert)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SKStoreReviewController.requestReviewInCurrentScene()
            }
        }
    }
    
    private func prepareCustomRatePopup(for alert: AlertType) {
        AppRouter.shared.topViewController()?.showAlertWithTwoActions(
            title: alert.title,
            message: alert.subtitle,
            action1Title: alert.action1Title,
            action1Handler: { _ in
            },
            action2Title: alert.action2Title,
            action2Handler: { _ in
                Defaults[.isLovedBefore] = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    SKStoreReviewController.requestReviewInCurrentScene()
                }
            },
            onlyGreat: alert == .ready ? false : alert == .onboard ? false : true
        )
    }
    
    func showWelcomeAlert() {
        let router = WelcomePromptRouter()
        let viewModel = WelcomePromptViewModel(router: router)
        let viewController = WelcomePromptViewController(viewModel: viewModel)
        
        let transition = ModalTransition(isAnimated: true, modalTransitionStyle: .coverVertical, modalPresentationStyle: .overFullScreen)
        router.viewController = viewController
        router.openTransition = transition
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve

        AppRouter.shared.topViewController()?.present(viewController, animated: true)
    }
    
    
    func ratingPromptCounterLogic() -> Bool {
        if Defaults[.isLovedBefore] {
            if !Defaults[.isBonusRatingSeen] {
                Defaults[.isBonusRatingSeen] = true
                return true
            } else {
                return false
            }
        }
        
        if askCount > 2 {
            return false
        } else {
            return true
        }
    }
}

public enum AlertType {
    case welcome, download, share, print, ready, onboard
    
    var title: String {
        switch self {
        case .welcome:
            return ""
        case .download:
            return L10n.Screens.Rating.Download.title
        case .share:
            return L10n.Screens.Rating.Share.title
        case .print:
            return L10n.Screens.Rating.Print.title
        case .ready:
            return L10n.Screens.Rating.Ready.title
        case .onboard:
            return L10n.Screens.Rating.Onboard.title
        }
    }
    
    var subtitle: String {
        switch self {
        case .welcome:
            return ""
        case .download:
            return L10n.Screens.Rating.Download.desc
        case .share:
            return L10n.Screens.Rating.Share.desc
        case .print:
            return L10n.Screens.Rating.Print.desc
        case .ready:
            return L10n.Screens.Rating.Ready.desc
        case .onboard:
            return L10n.Screens.Rating.Onboard.desc
        }
    }
    
    var action1Title: String {
        switch self {
        case .ready, .onboard:
            return L10n.Screens.Rating.next
        default:
            return ""
        }
    }
    
    var action2Title: String {
        switch self {
        case .ready:
            return L10n.Screens.Rating.sure
        default:
            return L10n.Screens.Rating.great
        }
    }
}

public extension SKStoreReviewController {
    static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
