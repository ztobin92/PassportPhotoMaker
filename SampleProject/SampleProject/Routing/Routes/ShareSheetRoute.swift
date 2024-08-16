//
//  ShareSheetRoute.swift
//  SampleProject
//
//  Created by Murat Celebi on 04.06.2021.
//  Copyright © 2021 Mobillium. All rights reserved.
//

import UIKit

protocol ShareSheetRoute {
    func presentShareSheet(items: [Any], withRate: Bool)
}

extension ShareSheetRoute where Self: RouterProtocol {
    
    func presentShareSheet(items: [Any], withRate: Bool = false) {
        let shareSheetController = withRate ? ActivityViewControllerWithRate(activityItems: items, applicationActivities: nil) : UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        shareSheetController.popoverPresentationController?.sourceView = AppRouter.shared.topViewController()?.view
        shareSheetController.popoverPresentationController?.sourceRect = .init(x: ScreenSize.width / 2, y: ScreenSize.height / 2, width: 0, height: 0)
        
        let transition = ModalTransition()
        
        open(shareSheetController, transition: transition)
    }
}

public final class ActivityViewControllerWithRate: UIActivityViewController {
    public override init(activityItems: [Any], applicationActivities: [UIActivity]?) {
        super.init(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            RatingHelper.shared.increaseLikeCountAndShowRatePopup(for: .share)
        }
    }
}
