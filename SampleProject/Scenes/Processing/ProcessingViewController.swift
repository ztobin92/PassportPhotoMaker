//
//  ProcessingViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import UIKit
import Lottie

final class ProcessingViewController: BaseViewController<ProcessingViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

//MARK: - UI Layout
extension ProcessingViewController {
    private func setupUI() {
        let animation = LottieAnimationView(name: "LoadingLottie")
        animation.play()
        animation.loopMode = .loop
        
        let titleLabel = UILabelBuilder()
            .text(L10n.Screens.Processing.title)
            .font(.systemFont(ofSize: 30, weight: .bold))
            .textAlignment(.center)
            .build()
        
        let descLabel = UILabelBuilder()
            .text(L10n.Screens.Processing.desc)
            .font(.systemFont(ofSize: 15, weight: .regular))
            .textColor(.secondaryLabel)
            .numberOfLines(0)
            .textAlignment(.center)
            .build()
        
        view.hstack(
            view.stack(
                animation,
                titleLabel,
                descLabel,
                alignment: .center
            ),
            alignment: .center
        )
        .withMargins(.allSides(40))
    }
}
