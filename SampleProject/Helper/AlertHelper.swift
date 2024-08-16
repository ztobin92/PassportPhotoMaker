//
//  AlertHelper.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.11.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation

public final class AlertHelper {
    static let shared = AlertHelper()
    
    func showAlert(title: String, desc: String) {
        let alertController = UIAlertController(title: title,
                                                message: desc,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in}
        alertController.addAction(okAction)
        AppRouter.shared.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}
