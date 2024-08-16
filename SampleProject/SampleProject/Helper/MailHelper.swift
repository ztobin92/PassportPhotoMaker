//
//  MailHelper.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import MessageUI

public final class MailHelper {
    static let shared = MailHelper()
    
    func createEmailUrl(to: String, subject: String, body: String) -> URL? {
         let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
         let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

         let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
         let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
         let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
         let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
         let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

         if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
             return gmailUrl
         } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
             return outlookUrl
         } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
             return yahooMail
         } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
             return sparkUrl
         }

         return defaultUrl
     }
    
    func prepareComposer() -> MFMailComposeViewController {
        let device = UIDevice.current
        let iOSVersion = device.systemVersion
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        guard let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? Bundle.main.infoDictionary?["CFBundleName"] as? String else {return .init()}
        let userID = UIDevice.current.identifierForVendor?.uuidString
        
        let recipientEmail = "hi@appelio.com"
        let subject = "Feedback for \(appName)"
        let body = """
                Hi, I want to contact you about the app \(appName).
                
                
                ——
                Please don’t delete the info below. It will help us to help you faster and better.
                
                iOS Version: \(iOSVersion)
                Device Name: \(device.name)
                App Version: \(appVersion ?? "")
                User Language: "en"
                User ID: \(userID ?? "")
                """
        let composer = MFMailComposeViewController()
        composer.setToRecipients([recipientEmail])
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)
        return composer
    }
    
}
