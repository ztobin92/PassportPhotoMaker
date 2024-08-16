//
//  PresentInSafariRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import SafariServices

protocol PresentSafariRoute {
    func presentInSafari(with url: URL)
}

extension PresentSafariRoute where Self: RouterProtocol {

    func presentInSafari(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .label
        let transition = ModalTransition()

        open(safariVC, transition: transition)
    }
}
