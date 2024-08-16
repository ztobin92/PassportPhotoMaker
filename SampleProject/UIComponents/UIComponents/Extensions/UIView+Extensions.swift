//
//  UIView+Extensions.swift
//  UIComponents
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation

final class ClickListener: UITapGestureRecognizer {
    private var action: () -> Void

    init(_ action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc
    private func execute() {
        action()
    }
}

public extension UIView {
    func onTap(_ action: @escaping () -> Void) {
        self.isUserInteractionEnabled = true
        let click = ClickListener(action)
        self.addGestureRecognizer(click)
    }
}
