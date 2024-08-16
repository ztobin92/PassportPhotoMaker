//
//  RevenueHelper.swift
//  SampleProject
//
//  Created by Bora Erdem on 29.09.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import Qonversion
import Defaults

public enum RevenueResult {
    case premiumCompleted, normalFinished, failure
}

public final class RevenueHelper: NSObject {
    
    public static let shared = RevenueHelper()

    
    override init() {
        super.init()
        Qonversion.shared().setEntitlementsUpdateListener(self)
    }
        
    private var products: [Offering: Qonversion.Product] = [:]
    var isPackagesFetched = false
    var updateUI: VoidClosure?
    
    enum Offering {
        case weekly, yearly
    }
    
    func fetchProdutcs() {
        
        Qonversion.shared().products { [weak self] productList, err in
            guard let self = self else {return}
            
            if err != nil {
                return
            }
            
            products[.yearly] = productList["yearly_pro_passport"]
            products[.weekly] = productList["weekly_pro_passport"]
            isPackagesFetched = true
            checkEntitlements()
            updateUI?()
        }
    }
    
    func getPackage(for type: Offering) -> Qonversion.Product? {
        guard isPackagesFetched else {return nil}
        return products[type]
    }
    
    func checkEntitlements() {
        Qonversion.shared().checkEntitlements { (entitlements, error) in
            if let _ = error {
                return
            }
            
            if let premium: Qonversion.Entitlement = entitlements["pro"], premium.isActive {
                switch premium.renewState {
                case .willRenew, .nonRenewable:
                    // .willRenew is the state of an auto-renewable subscription
                    // .nonRenewable is the state of consumable/non-consumable IAPs that could unlock lifetime access
                    break
                case .billingIssue:
                    // Grace period: entitlement is active, but there was some billing issue.
                    // Prompt the user to update the payment method.
                    break
                case .cancelled:
                    // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
                    // Prompt the user to resubscribe with a special offer.
                    break
                default: break
                }
                
                Defaults[.premium] = true
                return
            }
            
            Defaults[.premium] = false
            return
        }
        
    }
    
    func restorePurchases(completion: @escaping (RevenueResult)->()) {
        Qonversion.shared().restore { (entitlements, error) in
            if error != nil {
                completion(.failure)
                return
            }
            
            if let entitlement: Qonversion.Entitlement = entitlements["pro"], entitlement.isActive {
                Defaults[.premium] = true
                completion(.premiumCompleted)
                return
            }
            
            Defaults[.premium] = false
            completion(.normalFinished)
        }
    }
    
    func purchasePackage(for type: Offering, completion: @escaping (RevenueResult)->()) {
        
        guard let product = getPackage(for: type) else {
            ToastPresenter.showWarningToast(text: "Please try again in a few seconds until the current offers are available.")
            completion(.failure)
            return
        }
        
        Qonversion.shared().purchaseProduct(product) { (entitlements, error, isCancelled) in
            if let premium: Qonversion.Entitlement = entitlements["pro"], premium.isActive {
                Defaults[.premium] = true
                completion(.premiumCompleted)
                return
            }
            
            completion(.normalFinished)
            return
        }
    }
    
}

extension RevenueHelper: Qonversion.EntitlementsUpdateListener {
    public func didReceiveUpdatedEntitlements(_ entitlements: [String : Qonversion.Entitlement]) {
        if let premium: Qonversion.Entitlement = entitlements["pro"], premium.isActive {
            Defaults[.premium] = true
        } else {
            Defaults[.premium] = false
        }
    }
    
}

