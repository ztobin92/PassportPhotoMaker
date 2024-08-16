//
//  ResizeButton.swift
//  UIComponents
//
//  Created by Bora Erdem on 18.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import UIKit

public class ResizeButton: UIButton {
    
    public var width: CGFloat!
    public var height: CGFloat!
    
    public init(text: String, width: CGFloat, height: CGFloat) {
        super.init(frame: .zero)
        self.title.text = text
        self.width = width
        self.height = height
        configureContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureContents()
    }
    
    public let title = UILabelBuilder()
        .font(.systemFont(ofSize: 12, weight: .semibold))
        .textAlignment(.center)
        .backgroundColor(.lightGray)
        .textColor(.white)
        .build()
    
    private func configureContents() {
        layer.cornerRadius = 4
        clipsToBounds = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach {$0.removeFromSuperview()}
        
        let rectangle = UIViewBuilder()
            .borderColor(UIColor.white.cgColor)
            .borderWidth(2)
            .clipsToBounds(true)
            .build()
        
        let width =  frame.width * 0.5
        rectangle.withSize(.init(width: width, height: width * (self.height / self.width)))
        
        let rectangleContainer = UIView().stack(hstack(rectangle, alignment: .center), alignment: .center)
        rectangleContainer.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        stack(
            rectangleContainer.withHeight(frame.height * 0.8),
            title
        )
    }
    
    public func selectButton() {
        title.backgroundColor = .systemBlue
    }
    
    public func deselectButton() {
        title.backgroundColor = .lightGray
    }
    
}
