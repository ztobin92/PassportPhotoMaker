//
//  PaywallRoute.swift
//  AirShareKit
//
//  Created by Furkan Hanci on 1/11/23.
//

import SwiftUI

protocol PaywallRoute {
    func presentPaywall(showPaywallWhenDisappear: Bool)
}

extension PaywallRoute where Self: RouterProtocol {

    func presentPaywall(showPaywallWhenDisappear: Bool = false) {
        let router = PaywallRouter()
        let viewController = PaywallView(router: router, showPaywallWhenDisappear: showPaywallWhenDisappear)
        let hosting = UIHostingController(rootView: viewController)
        let transition = ModalTransition()
        router.viewController = hosting
        router.openTransition = transition
        open(hosting, transition: transition)
    }
}
