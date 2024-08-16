//
//  HomeActionButton.swift
//  UIComponents
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import UIKit
import MobilliumBuilders
import LBTATools

public class HomeActionButton: HighlightedView {
    
    weak var viewModel: HomeActionButtonProtocol?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureContents()
    }
    
    private let imageView = UIImageViewBuilder()
        .contentMode(.scaleAspectFit)
        .build()
    
    private let titleLabel = UILabelBuilder()
        .font(.systemFont(ofSize: 22, weight: .bold))
        .adjustsFontSizeToFitWidth(true)
        .textAlignment(.center)
        .numberOfLines(0)
        .build()
    
    private let descLabel = UILabelBuilder()
        .font(.systemFont(ofSize: 13, weight: .regular))
        .textAlignment(.center)
        .adjustsFontSizeToFitWidth(true)
        .textColor(.secondaryLabel)
        .numberOfLines(0)
        .build()
    
    private func configureContents() {
        backgroundColor = .white
        layer.cornerRadius = 8
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach({$0.removeFromSuperview()})
        hstack(
            stack(
                imageView.withHeight(frame.height * 0.45),
                titleLabel,
                descLabel,
                spacing: 5
            )
            .withMargins(.allSides(10)),
            alignment: .center
        )
    }
    
    public func set(viewModel: HomeActionButtonProtocol) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        descLabel.text = viewModel.desc
        imageView.image = viewModel.image.resize(to: .init(width: 300, height: 300), for: .scaleAspectFit)
    }
    
}
