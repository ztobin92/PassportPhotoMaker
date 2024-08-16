//
//  HomeViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import UIKit
import LBTATools
import PhotosUI
import MobilliumBuilders
import Defaults

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    let cameraButton = HomeActionButton()
    let galleryButton = HomeActionButton()
    let cloudButton = HomeActionButton()
    
    var titleLabel: UILabel = {
        UILabelBuilder()
            .font(.systemFont(ofSize: 18))
            .textColor(.secondaryLabel)
            .text(L10n.Screens.Home.desc)
            .build()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
        customizeButtons()
    }
    
    func setupNav() {
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "gearshape.fill")!, style: .plain, target: self, action: #selector(didTapGoSettings))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = L10n.Screens.Home.title
        customizeButtons()
        titleLabel.text = L10n.Screens.Home.desc
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func customizeButtons() {
        //Camera Button
        cameraButton.set(
            viewModel: HomeActionButtonModel(
                image: .camera,
                title: L10n.Screens.Home.Photo.title,
                desc: L10n.Screens.Home.Photo.desc
            )
        )
        
        galleryButton.set(
            viewModel: HomeActionButtonModel(
                image: .gallery ,
                title: L10n.Screens.Home.Gallery.title,
                desc: L10n.Screens.Home.Gallery.desc
            )
        )
        
        cloudButton.set(
            viewModel: HomeActionButtonModel(
                image: .cloud ,
                title: L10n.Screens.Home.Icloud.title,
                desc: L10n.Screens.Home.Icloud.desc
            )
        )
    }
    
}

// MARK: - UI Layout
extension HomeViewController {
    func setupUI() {
        view.stack(
            titleLabel,
            prepareButtons(),
            UIView(),
            spacing: 20
        ).padLeft(16).padRight(16)
    }
    
    private func prepareButtons() -> UIView {
        let container = UIView()
        
        cameraButton.onTap { [weak self] in
            guard let self = self else {return}
            if !Defaults[.premium], Defaults[.remainingCount] < 1 {
                viewModel.router.presentPaywall()
                return
            }
            
            Defaults[.remainingCount] -= 1
            viewModel.didTapTakePhoto()
        }
        
        // Gallery Button
        galleryButton.onTap { [weak self] in
            guard let self = self else {return}
            if !Defaults[.premium], Defaults[.remainingCount] < 1 {
                viewModel.router.presentPaywall()
            }
            
            Defaults[.remainingCount] -= 1
            viewModel.didTapPickPhotoFromGallery()
        }
        
        // Cloud Button
        cloudButton.onTap { [weak self] in
            guard let self = self else {return}
            if !Defaults[.premium], Defaults[.remainingCount] < 1 {
                viewModel.router.presentPaywall()
                return
            }
            
            Defaults[.remainingCount] -= 1
            viewModel.didTapPickPhotoFromCloud()
        }
        
        container.stack(
            container.hstack(
                cameraButton,
                galleryButton,
                spacing: 20,
                distribution: .fillEqually
            )
            .withHeight(ScreenSize.height * 0.25),
            
            container.hstack(
                cloudButton,
                UIView(),
                spacing: 20,
                distribution: .fillEqually
            )
            .withHeight(ScreenSize.height * 0.25),
            
            spacing: 20
        )
        
        return container
    }
    
}

// MARK: - Objc
extension HomeViewController {
    @objc func didTapGoSettings() {
        viewModel.router.pushSettings()
    }
}
