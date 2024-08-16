//
//  ComposerRouteRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

protocol ComposerRoute {
    func presentComposer(composer: UINavigationController)
}

extension ComposerRoute where Self: RouterProtocol {
    
    func presentComposer(composer: UINavigationController) {
        open(composer, transition: ModalTransition(animator: .none, isAnimated: true, modalTransitionStyle: .coverVertical, modalPresentationStyle: .pageSheet))
    }
}
