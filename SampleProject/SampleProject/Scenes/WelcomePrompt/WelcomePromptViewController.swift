//
//  WelcomePromptViewController.swift
//  NewWatchFacesApp
//
//  Created by Bora Erdem on 22.05.2023.
//

import UIKit
import Defaults
import StoreKit

final class WelcomePromptViewController: BaseViewController<WelcomePromptViewModel> {
    
    let container = UIViewBuilder()
        .cornerRadius(25)
        .backgroundColor(.white)
        .clipsToBounds(true)
        .build()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

extension WelcomePromptViewController {
    private func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
        preparePopupView()
    }
    
    private func preparePopupView() {
        let width = ScreenSize.width * 0.9
        
        let bannerImageView = UIImageViewBuilder()
            .image(.clap)
            .contentMode(.scaleAspectFit)
            .build()
        
        let titleLabel = UILabelBuilder()
            .font(.systemFont(ofSize: 24, weight: .semibold))
            .numberOfLines(0)
            .textAlignment(.center)
            .text(L10n.Screens.Alert.Welcome.title)
            .build()
        
        let descLabel = UILabelBuilder()
            .font(.systemFont(ofSize: 13, weight: .regular))
            .text(L10n.Screens.Alert.Welcome.desc)
            .numberOfLines(0)
            .textColor(.secondaryLabel)
            .textAlignment(.center)
            .build()
        
        let reviewButton = UIButtonBuilder()
            .titleFont(.systemFont(ofSize: 17, weight: .bold))
            .title(L10n.Screens.Alert.Welcome.yes)
            .titleColor(.white)
            .backgroundColor(.systemBlue)
            .cornerRadius(25)
            .button
        
        reviewButton.onTap { [weak self] in
            Defaults[.isLovedBefore] = true
            SKStoreReviewController.requestReviewInCurrentScene()
            self?.viewModel.router.close()
        }
        
        let laterLabel = UILabelBuilder()
            .textColor(.secondaryLabel)
            .font(.systemFont(ofSize: 15, weight: .regular))
            .text(L10n.Screens.Alert.Welcome.no)
            .textAlignment(.center)
            .build()
        
        laterLabel.onTap { [weak self] in
            self?.viewModel.router.close()
        }
        
        let buttonStack = container.stack(
            container.stack(reviewButton.withHeight(50)),
            laterLabel,
            spacing: 10
        )
        
        let contentStack = container.hstack(
            container.stack(
                titleLabel,
                descLabel,
                buttonStack,
                spacing: 20,
                distribution: .equalSpacing
            ),
            alignment: .center
        )
        
        container.stack(
            UIView(),
            bannerImageView.withHeight(width * 0.4),
            UIView(),
            contentStack,
            distribution: .equalSpacing
        ).withMargins(.init(top: 40, left: 20, bottom: 20, right: 20))
        
        container.withSize(.init(width: width, height: width * 1.25))
        view.addSubview(container)
        container.centerInSuperview()
    }
}

