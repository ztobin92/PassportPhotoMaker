//
//  Observers.swift
//  SampleProject
//
//  Created by Bora Erdem on 16.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import Combine

public let closeProcessing = PassthroughSubject<Void, Never>()
public let sharedOriginalImage = CurrentValueSubject<UIImage, Never>(UIImage())
