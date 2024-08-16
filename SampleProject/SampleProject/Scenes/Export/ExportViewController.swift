//
//  ExportViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 19.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import UIKit

final class ExportViewController: BaseViewController<ExportViewModel> {
    
    var imageToShare: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            RatingHelper.shared.increaseLikeCountAndShowRatePopup(for: .ready)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = L10n.Screens.Export.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.imageToShare = self?.prepareImageForExport()
        }
    }
    
    private func setupNav() {
        navigationItem.rightBarButtonItem = .init(systemItem: .close, primaryAction: .init(handler: { [weak self] _ in
            self?.viewModel.router.close()
        }))
    }
    
}

//MARK: - UI Layout
extension ExportViewController {
    private func setupUI() {
        view.stack(
            titleLabel,
            imageView,
            buttonStack,
            spacing: 20, distribution: .equalSpacing
        ).padLeft(16).padRight(16).padBottom(16)
    }
    
    var titleLabel: UILabel {
        UILabelBuilder()
            .font(.systemFont(ofSize: 18))
            .textColor(.secondaryLabel)
            .text(L10n.Screens.Export.desc)
            .numberOfLines(0)
            .build()
    }
    
    var imageView: UIView {
        view.stack(
            UIImageViewBuilder()
                .contentMode(.scaleAspectFill)
                .backgroundColor(viewModel.bgColor)
                .cornerRadius(20)
                .borderWidth(3)
                .clipsToBounds(true)
                .borderColor(UIColor.white.cgColor)
                .image(viewModel.image)
                .build().withSize(.init(width: ScreenSize.width * 0.6, height: ScreenSize.width * 0.6 * viewModel.ratio)),
            alignment: .center
        )
    }
    
    var buttonStack: UIView {
        
        let download = prepareActionButton(
            title: L10n.Screens.Export.download,
            desc: L10n.Screens.Export.Download.desc,
            image: .gallery
        )
        
        download.onTap { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.viewModel.didTapDownload(image: self.prepareImageForExport())
                AlertHelper.shared.showAlert(
                    title: L10n.Screens.Export.Download.Alert.title,
                    desc: L10n.Screens.Export.Download.Alert.desc
                )
            }
        }
        
        let print = prepareActionButton(
            title: L10n.Screens.Export.print,
            desc: L10n.Screens.Export.Print.desc,
            image: .printer
        )
        
        print.onTap {[weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.viewModel.didTapPrint(image: self.prepareImageForExport())
            }
        }
        
        let share = prepareActionButton(
            title: L10n.Screens.Export.share,
            desc: L10n.Screens.Export.Share.desc,
            image: .share
        )
        
        share.onTap {[weak self] in
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.viewModel.didTapShare(image: self.prepareImageForExport())
            }
        }
        
        return view.stack(
            download,
            print,
            share,
            spacing: 10
        )
    }
    
    private func prepareImageForExport() -> UIImage {
        
        if imageToShare != nil {
            return imageToShare!
        }
        let lastSize = CGSize(width: lastSize.value.width * 1.5, height: lastSize.value.height * 1.5)
        
        let widthInPoints: CGFloat
        let heightInPoints: CGFloat
        
        switch lastMetric.value {
        case .mm:
            widthInPoints = lastSize.width * 2.83465 // 1 mm ≈ 2.83465 points
            heightInPoints = lastSize.height * 2.83465
        case .cm:
            widthInPoints = lastSize.width * 28.3465 // 1 cm ≈ 28.3465 points
            heightInPoints = lastSize.height * 28.3465
        case .inch:
            widthInPoints = lastSize.width * 72 // 1 inch = 72 points
            heightInPoints = lastSize.height * 72
        }

        
        let newImageView = UIImageViewBuilder()
            .contentMode(.scaleAspectFill)
            .backgroundColor(self.viewModel.bgColor)
            .image(self.viewModel.image)
            .build().withSize(.init(width: widthInPoints, height: widthInPoints * self.viewModel.ratio))
        
        let renderer = UIGraphicsImageRenderer(size: .init(width: widthInPoints, height: widthInPoints * self.viewModel.ratio))
        let image = renderer.image { ctx in
            newImageView.drawHierarchy(in: .init(x: 0, y: 0, width: widthInPoints, height: widthInPoints * self.viewModel.ratio), afterScreenUpdates: true)
        }
        
        imageToShare = image
        return image
    }
    
    private func prepareActionButton(title: String, desc: String, image: UIImage) -> HighlightedView {
        let container = HighlightedView()
        container.layer.cornerRadius = 8
        container.backgroundColor = .white
        let height = ScreenSize.height * 0.08
        container.withHeight(height)
        
        let imageView = UIImageViewBuilder()
            .contentMode(.scaleAspectFit)
            .image(image)
            .build()
        
        let titleLabel = UILabelBuilder()
            .text(title)
            .adjustsFontSizeToFitWidth(true)
            .font(.systemFont(ofSize: 22, weight: .semibold))
            .build()
        
        let descLabel = UILabelBuilder()
            .text(desc)
            .textColor(.secondaryLabel)
            .font(.systemFont(ofSize: 13, weight: .medium))
            .build()
        
        container.hstack(
            imageView.withWidth(height * 0.7),
            container.stack(titleLabel, descLabel),
            UIView(),
            spacing: 10,
            alignment: .center
        ).withMargins(.init(top: 0, left: 10, bottom: 0, right: 10))
        
        
        return container
    }

}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
