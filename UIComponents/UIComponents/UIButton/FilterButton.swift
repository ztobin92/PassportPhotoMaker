//
//  FilterButton.swift
//  UIComponents
//
//  Created by Bora Erdem on 18.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation

public final class FilterButton: UIButton {
    
    var titleString: String!
    public var filterName: String!
    var image: UIImage!
    
    lazy public var filterImageView = UIImageView(image: .camera, contentMode: .scaleAspectFill)
    
    public let title = UILabelBuilder()
        .font(.systemFont(ofSize: 12, weight: .semibold))
        .textAlignment(.center)
        .backgroundColor(.lightGray)
        .adjustsFontSizeToFitWidth(true)
        .textColor(.white)
        .build()
    
    public  init(title: String, filterName: String, image: UIImage) {
        super.init(frame: .zero)
        self.title.text = title
        self.filterName = filterName
        self.image = image.resize(to: .init(width: 200, height: 200), for: .scaleAspectFit)
        
        layer.cornerRadius = 4
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        clipsToBounds = true
        
        if title == "None" {
            filterImageView.image = image
            return
        }
        
        let context = CIContext(options: nil)
        guard let ciImage = CIImage(image: image) else { return}
        guard let filter = CIFilter(name: filterName) else { return }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let output = filter.outputImage,
           let cgImage = context.createCGImage(output, from: output.extent) {
            var result = UIImage(cgImage: cgImage)
            var orientation: UIImage.Orientation = .up
            if result.size.width > result.size.height { orientation = .right } else { orientation = .up }
            filterImageView.image = UIImage(cgImage: cgImage, scale: image.scale, orientation: orientation)
        }

    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach {$0.removeFromSuperview()}
        
        let rectangleContainer = UIView().stack(filterImageView)
        rectangleContainer.backgroundColor = .white
        
        stack(
            rectangleContainer.withHeight(frame.height * 0.8),
            title
        )

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func selectButton() {
        title.backgroundColor = .systemBlue
    }
    
    public func deselectButton() {
        title.backgroundColor = .lightGray
    }

}
