//
//  DefaultKeys.swift
//  SampleProject
//
//  Created by Bora Erdem on 19.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import Defaults

public extension Defaults.Keys {
    static let isLovedBefore = Key<Bool>("isLovedBefore", default: false)
    static let isBonusRatingSeen = Key<Bool>("isBonusRatingSeen", default: false)
    static let totalRatingAskCount = Key<Int>("totalRatingAskCount", default:  0)
    static let isInstructionsShown = Key<Bool>("isInstructionsShown", default: false)
    static let premium = Key<Bool>("premium", default: false)
    static let isFirstRun = Key<Bool>("isFirstRun", default: false)
    static let remainingCount = Key<Int>("remainingCount", default: 3)
    static let prefferedLanguage = Key<String?>("prefferedLanguage")
}

