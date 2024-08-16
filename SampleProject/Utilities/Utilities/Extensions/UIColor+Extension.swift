//
//  UIColor+Extension.swift
//  Utilities
//
//  Created by Bora Erdem on 23.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(hexString: String) {
            var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if hexString.hasPrefix("#") {
                hexString.remove(at: hexString.startIndex)
            }
            
            if hexString.count != 6 {
                self.init(white: 1.0, alpha: 1.0)
                return
            }
            
            var rgbValue: UInt64 = 0
            Scanner(string: hexString).scanHexInt64(&rgbValue)
            
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        }
}
