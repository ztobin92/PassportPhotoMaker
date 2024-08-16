//
//  HomeActionButtonModel.swift
//  UIComponents
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation

public protocol HomeActionButtonDataSource: AnyObject {
    var image: UIImage {get}
    var title: String {get}
    var desc: String {get}
}

public protocol HomeActionButtonEventSource: AnyObject {
    
}

public protocol HomeActionButtonProtocol: HomeActionButtonDataSource, HomeActionButtonEventSource {
    
}

public final class HomeActionButtonModel: HomeActionButtonProtocol {
    public var image: UIImage
    public var title: String
    public var desc: String
    
    public init (image: UIImage, title: String, desc: String) {
        self.image = image
        self.title = title
        self.desc = desc
    }
}
