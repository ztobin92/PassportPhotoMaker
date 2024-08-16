//
//  Filter.swift
//  DataProvider
//
//  Created by Bora Erdem on 19.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation

public class Filter {
    public var title: String
    public var filterID: String
    
    public init(title: String, filterID: String) {
        self.title = title
        self.filterID = filterID
    }
}
