//
//  SettingsViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.stack(tableView)
        
        viewModel.reloadData = { [weak self] in
            guard let self = self else {return}
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.configureItems()
        title = L10n.Screens.Settings.title
    }
    
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsAt(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueReusableCell(for: indexPath)
        let cellItem = viewModel.cellItemAt(indexPath: indexPath)
        cell.set(viewModel: cellItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellItemAt(indexPath: indexPath).action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
