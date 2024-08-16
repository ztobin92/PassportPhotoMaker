//
//  UIViewController+Extension.swift
//  UIComponents
//
//  Created by Bora Erdem on 19.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation

public extension UIViewController {
    func showAlertWithTwoActions(title: String?, message: String?, action1Title: String, action1Style: UIAlertAction.Style = .default, action1Handler: ((UIAlertAction) -> Void)? = nil, action2Title: String, action2Style: UIAlertAction.Style = .default, action2Handler: ((UIAlertAction) -> Void)? = nil, extras: ((UIAlertController)->())? = nil, isPaywall: Bool = false, onlyGreat: Bool = true) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: action1Title, style: action1Style, handler: action1Handler)
        
        let action2 = UIAlertAction(title: action2Title, style: action2Style, handler: action2Handler)
        
        
        if onlyGreat {
            alertController.addAction(action2)
        } else {
            if isPaywall {
                alertController.addAction(action2)
                alertController.addAction(action1)
            } else {
                alertController.addAction(action1)
                alertController.addAction(action2)
            }
        }
        

        
        alertController.preferredAction = action2
        
        extras?(alertController)
        
        present(alertController, animated: true, completion: nil)
    }
}
