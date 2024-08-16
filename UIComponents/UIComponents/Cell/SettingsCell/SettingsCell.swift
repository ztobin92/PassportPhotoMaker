//
//  SettingsCell.swift
//  UIComponents
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import UIKit
import MobilliumBuilders

public class SettingsCell: UITableViewCell, ReusableView {
    
    weak var viewModel: SettingsCellProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContents()
    }
    
    private let chevron = UIImageViewBuilder()
        .contentMode(.scaleAspectFit)
        .build()
    
    private func configureContents() {
        selectionStyle = .default
    }
    
    public func set(viewModel: SettingsCellProtocol) {
        self.viewModel = viewModel
        imageView?.image = viewModel.image
        textLabel?.text = viewModel.title
        accessoryType = .disclosureIndicator
    }
    
}
