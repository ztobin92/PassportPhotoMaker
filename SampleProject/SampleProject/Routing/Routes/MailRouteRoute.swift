//
//  MailRouteRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 17.07.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

protocol MailRoute {
    func sendMailSheet(composer: UINavigationController)
}

extension MailRoute where Self: RouterProtocol {
    func sendMailSheet(composer: UINavigationController) {
        open(composer, transition: ModalTransition(isAnimated: true, modalTransitionStyle: .coverVertical, modalPresentationStyle: .pageSheet))
    }
}
