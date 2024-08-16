//
//  EditViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 16.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import UIKit
import MobilliumBuilders
import Combine
import Mantis
import Instructions
import Defaults

final class EditViewController: BaseViewController<EditViewModel> {
    
    var menuButtons = [UIButton]()
    var resizeButtons = [ResizeButton]()
    var filterButtons = [FilterButton]()
    var customizeRef = UIView()
    var cancellable = Set<AnyCancellable>()
    var imageHeightAnchor: NSLayoutConstraint!
    var imageWidthAnchor: NSLayoutConstraint!
    var imageContainerRef = UIView()
    lazy var croppedImage = viewModel.image.resize(to: .init(width: 1000, height: 1000), for: .scaleAspectFit)
    
    let coachMarksController = CoachMarksController()
    
    let customSizeButton = UIButtonBuilder()
        .backgroundColor(.systemBlue)
        .image(.init(systemName: "slider.horizontal.3")!, for: .normal)
        .titleColor(.white)
        .tintColor(.white)
        .cornerRadius(4)
        .button

    lazy var imageView = UIImageViewBuilder()
        .contentMode(.scaleAspectFill)
        .backgroundColor(.white)
        .clipsToBounds(true)
        .build()
    
    let scrollView = UIScrollView()
    var doneButton = UIView()
    var customSizeButtonRef = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
        subscribeViewModel()
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        self.coachMarksController.overlay.isUserInteractionEnabled = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastMetric.send(.inch)
        lastSize.send(.init(width: 2, height: 2))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !Defaults[.isInstructionsShown] {
            self.coachMarksController.start(in: .window(over: self))
            Defaults[.isInstructionsShown] = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageView.image = nil
        imageView.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuButtons.forEach { button in
            DispatchQueue.main.async {
                button.layer.cornerRadius = button.bounds.size.height / 2
            }
        }
    }
    
    private func setupNav() {
        navigationItem.rightBarButtonItem = .init(title: L10n.Screens.Edit.done, style: .plain, target: self, action: #selector(didTapDone))
        doneButton = UIButton(title: L10n.Screens.Edit.done, titleColor: .systemBlue, font: .systemFont(ofSize: 17, weight: .semibold))
        navigationItem.rightBarButtonItem?.customView = doneButton
        doneButton.onTap { [weak self] in
            UIImpactFeedbackGenerator().impactOccurred()
            self?.didTapDone()
        }
    }
    
    private func subscribeViewModel() {
        viewModel.updateImageBGColor = { [unowned self] color in
            imageView.backgroundColor = color
        }
    }
}

//MARK: - CoachMarksControllerDelegate
extension EditViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didHide coachMark: CoachMark, at index: Int) {
        if index == 1 {
            coachMarksController.flow.pause(and: .hideInstructions)
        }
    }
    
    func coachMarksController(_ coachMarksController: Instructions.CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: Instructions.CoachMark) -> (bodyView: (UIView & Instructions.CoachMarkBodyView), arrowView: (UIView & Instructions.CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )

        coachViews.bodyView.hintLabel.text = viewModel.instructions[index]
        coachViews.bodyView.nextLabel.text = L10n.Screens.Edit.ok

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: Instructions.CoachMarksController, coachMarkAt index: Int) -> Instructions.CoachMark {
        switch index {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: doneButton)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: scrollView)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: customizeRef)
        default:
            return .init()
        }
    }
    
    func numberOfCoachMarks(for coachMarksController: Instructions.CoachMarksController) -> Int {
        viewModel.instructions.count
    }
    
    
}

//MARK: - UIScrollViewDelegate
extension EditViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageContainerRef
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageContainerRef
    }
}

//MARK: - UI Layout
extension EditViewController {
    private func setupUI() {
        imageView.image = viewModel.image.resize(to: .init(width: 1000, height: 1000), for: .scaleAspectFit)
        
        let imageContainer = UIView().stack(imageView.withSize(.init(width: ScreenSize.width * 0.8, height: ScreenSize.width * 0.8)), alignment: .center)
        imageContainerRef = imageContainer
        
        let container = prepareMainContainer()
        customizeRef = prepareCustomizeContainer()
        
        let customizeContainer = container.stack(
            UIView(),
            customizeRef,
            prepareBottomMenu(),
            spacing: 0
        )
        
        container.stack(
            UIView(),
            customizeContainer
        )
        
        layoutScrollView(imageContainer)
    }
    
    private func layoutScrollView(_ imageContainer: UIView) {
        scrollView.layer.cornerRadius = 20
        scrollView.layer.borderColor = UIColor.white.cgColor
        scrollView.layer.borderWidth = 3
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(imageContainer)
        scrollView.clipsToBounds = true
        scrollView.layer.masksToBounds = true
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10

        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        imageHeightAnchor = scrollView.heightAnchor.constraint(equalToConstant: ScreenSize.width * 0.8)
        imageWidthAnchor = scrollView.widthAnchor.constraint(equalToConstant: ScreenSize.width * 0.8)
        
        imageHeightAnchor.isActive = true
        imageWidthAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let rotateButton = UIButtonBuilder()
            .image(.init(systemName: "rotate.left")!)
            .tintColor(.black)
            .build()
        rotateButton.imageView?.contentMode = .scaleAspectFit
        
        rotateButton.onTap {
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                if let rotatedImage = rotateImage(imageView.image!, by: .pi / -2) {
                    croppedImage = rotatedImage
                    imageView.image = rotatedImage
                }
            })
            

        }
        view.addSubview(rotateButton)
        rotateButton.withSize(.init(width: 25, height: 25))
        rotateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rotateButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            rotateButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10)
        ])

    }
    
    func rotateImage(_ image: UIImage, by angle: CGFloat) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            let context = UIGraphicsGetCurrentContext()!
            
            context.translateBy(x: image.size.width / 2, y: image.size.height / 2)
            context.rotate(by: angle)
            context.scaleBy(x: 1.0, y: -1.0)
            
            let drawRect = CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height)
            context.draw(image.cgImage!, in: drawRect)
            
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage
        }
    
    private func prepareMainContainer() -> UIView {
        let container = UIView()
        view.addSubview(container)
        container.fillSuperviewSafeAreaLayoutGuide()
        return container
    }
    
    private func prepareBottomMenu() -> UIView {
        
        let stack = UIView().hstack(spacing: 10, distribution: .fillEqually).padLeft(20).padRight(20).padBottom(10).padTop(10)
        stack.backgroundColor = .white
        
        [
            L10n.Screens.Edit.color,
            L10n.Screens.Edit.resize,
            L10n.Screens.Edit.filter
        ].forEach { title in
            let button = UIButtonBuilder()
                .title(title)
                .titleColor(.gray)
                .titleFont(.systemFont(ofSize: 24, weight: .medium))
                .backgroundColor(.clear)
                .button
            
            button.addTarget(nil, action: #selector(didTapCustomTypeButton(_:)), for: .touchUpInside)
            menuButtons.append(button)
            stack.addArrangedSubview(button)
        }
        
        menuButtons.first!.setTitleColor(.white, for: .normal)
        menuButtons.first!.backgroundColor = .systemBlue
        
        let safeAreaWhite = UIView(backgroundColor: .white)
        view.addSubview(safeAreaWhite)
        safeAreaWhite.anchor(
            .leading(view.leadingAnchor),
            .trailing(view.trailingAnchor),
            .bottom(view.bottomAnchor),
            .top(view.safeAreaLayoutGuide.bottomAnchor)
        )
        
        return stack
    }
    
    private func prepareCustomizeContainer() -> UIView {
        let container = UIView()
        container.withHeight(ScreenSize.height * 0.2)
        container.backgroundColor = .white
        container.layer.cornerRadius = 20
        container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let a = UIView().stack(prepareColorSection())
        let b = UIView().stack(prepareResizeSection())
        let c = UIView().stack(prepareFilterSection())
        
        b.isHidden = true
        c.isHidden = true
        
        container.stack(a,b,c)
        
        viewModel.selectedButton.sink { title in
            switch title {
            case L10n.Screens.Edit.color:
                a.isHidden = false
                b.isHidden = true
                c.isHidden = true
            case L10n.Screens.Edit.resize:
                a.isHidden = true
                b.isHidden = false
                c.isHidden = true
            case L10n.Screens.Edit.filter:
                a.isHidden = true
                b.isHidden = true
                c.isHidden = false
            default:
                break
            }
        }.store(in: &cancellable)
        
        container.setupShadow(opacity: 0.4, radius: 5, offset: .init(width: 5, height: 5), color: .black)
        
        return container
    }
    
    private func prepareColorSection() -> UIView {
        let scroll = UIScrollView()
        let superHeight = ScreenSize.height * 0.2
        scroll.withHeight(superHeight * 0.4)
        scroll.contentSize.height = superHeight * 0.4
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = false
        let container = UIView().hstack(spacing: 20).padRight(20)
        scroll.stack(container)

        //Color picker button
        let colorPickButton = UIButtonBuilder()
            .backgroundImage(.colorPicker)
            .button
        colorPickButton.withSize(.init(width: superHeight * 0.4, height: superHeight * 0.4))
        colorPickButton.onTap {[unowned self] in viewModel.didTapGoColorPicker()}
        container.addArrangedSubview(colorPickButton)
        
        //Colors
        
        viewModel.colors.forEach { color in
            let button = UIButtonBuilder()
                .backgroundColor(color)
                .cornerRadius(superHeight * 0.4 / 2)
                .borderColor(UIColor.black.cgColor)
                .borderWidth(1)
                .button
            button.withSize(.init(width: superHeight * 0.4, height: superHeight * 0.4))
            button.addTarget(self, action: #selector(didTapChangeColor(_:)), for: .touchUpInside)
            container.addArrangedSubview(button)
        }
        
        
        return UIView().hstack(colorPickButton, scroll,spacing: 20, alignment: .center).padLeft(20)
    }
    
    private func prepareResizeSection() -> UIView {
        let scroll = UIScrollView()
        let superHeight = ScreenSize.height * 0.2
        scroll.withHeight(superHeight * 0.5)
        scroll.contentSize.height = superHeight * 0.5
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = false
        let container = UIView().hstack(spacing: 20).padRight(20)
        scroll.stack(container)
        
        viewModel.sizes.forEach { sizeString in
            let size = sizeString.components(separatedBy: "x")
            if let width = Float(size[0]), let height = Float(size[1]) {
                let btn = ResizeButton(text: sizeString, width: CGFloat(width), height: CGFloat(height))
                btn.onTap {
                    [unowned self] in
                    didTapResize(btn)
                }
                resizeButtons.append(btn)
                btn.size(.init(width: superHeight * 0.5 * 0.8, height: superHeight * 0.5))
                container.addArrangedSubview(btn)
            }
        }
        
        resizeButtons.first!.selectButton()
        
        
        customSizeButton.titleEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        customSizeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        customSizeButton.titleLabel?.numberOfLines = 0
        customSizeButton.withSize(.init(width: superHeight * 0.5 * 0.8, height: superHeight * 0.5))
        
        customSizeButton.onTap { [weak self] in
            guard let self = self else {return}
            var config = Mantis.Config()
            config.cropToolbarConfig.backgroundColor = .white
            config.cropToolbarConfig.foregroundColor = .black
            let c: CustomCropViewController = Mantis.cropViewController(image: self.imageView.image!, config: config)
            c.modalTransitionStyle = .coverVertical
            c.modalPresentationStyle = .overCurrentContext
            c.delegate = self
            
            self.present(c, animated: true)
        }
        
        return view.hstack(customSizeButton, scroll,spacing: 20, alignment: .center).padLeft(20)
    }
    
    private func prepareFilterSection() -> UIView {
        let scroll = UIScrollView()
        let superHeight = ScreenSize.height * 0.2
        scroll.withHeight(superHeight * 0.5)
        scroll.contentSize.height = superHeight * 0.5
        scroll.bounces = false
        scroll.showsHorizontalScrollIndicator = false
        let container = UIView().hstack(spacing: 20).padRight(20).padLeft(20)
        scroll.stack(container)
        
        viewModel.filters.forEach { filter in
            let btn = FilterButton(title: filter.title, filterName: filter.filterID, image: imageView.image?.resize(to: .init(width: 300, height: 300), for: .scaleAspectFit) ?? UIImage())
            btn.onTap {[unowned self] in didTapFilter(btn)}
            filterButtons.append(btn)
            btn.size(.init(width: superHeight * 0.5 * 0.8, height: superHeight * 0.5))
            container.addArrangedSubview(btn)
        }
        
        filterButtons.first!.selectButton()

        return view.hstack(scroll,spacing: 20, alignment: .center)
    }
    
}

//MARK: - Objc
extension EditViewController {
    @objc func didTapCustomTypeButton(_ sender: UIButton) {
        UIImpactFeedbackGenerator().impactOccurred()
        
        if customizeRef.isHidden {
            viewModel.selectedButton.send(sender.titleLabel?.text ?? "")
            UIView.animate(withDuration: 0.4, delay: 0) { [weak self] in
                sender.backgroundColor =  .systemBlue
                sender.setTitleColor(.white , for: .normal)
                self?.customizeRef.isHidden.toggle()
            }
            return
        }
        
        menuButtons.forEach { btn in
            let selected = btn == sender
            btn.backgroundColor = selected ? .systemBlue : .clear
            btn.setTitleColor(selected ? .white : .lightGray, for: .normal)
        }
        
        
        if viewModel.selectedButton.value == sender.titleLabel?.text {
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else {return}
                self.customizeRef.isHidden.toggle()
                self.menuButtons.forEach { btn in
                    btn.backgroundColor =  .clear
                    btn.setTitleColor( .lightGray, for: .normal)

                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [unowned self] in
            viewModel.selectedButton.send(sender.titleLabel?.text ?? "")
        }
        
        
        if sender.titleLabel?.text == L10n.Screens.Edit.resize {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.coachMarksController.flow.resume()
            }
        }
        
    }
    
    @objc func didTapDone() {
        
        scrollView.layer.borderWidth = 0
        scrollView.layer.cornerRadius = 0
        
        let ratio = CGFloat(scrollView.frame.height / scrollView.frame.width)
        let color = imageView.backgroundColor!
        
        let renderer = UIGraphicsImageRenderer(size: .init(width: 1000, height: 1000 * ratio))
        let image = renderer.image { ctx in
            scrollView.drawHierarchy(in: .init(x: 0, y: 0, width: 1000, height: 1000 * ratio), afterScreenUpdates: true)
        }
        
        viewModel.router.presentExport(image: image, ratio: ratio, bgColor: color)
        viewModel.router.close()
    }
    
    @objc func didTapChangeColor(_ sender: UIButton) {
        UIImpactFeedbackGenerator().impactOccurred()
        imageView.backgroundColor = sender.backgroundColor
    }
    
    @objc func didTapResize(_ sender: ResizeButton) {
        UIImpactFeedbackGenerator().impactOccurred()
        
        imageWidthAnchor.isActive = false
        let new = imageContainerRef.widthAnchor.constraint(equalToConstant: ScreenSize.height * 0.65 / (sender.height / sender.width))
        imageWidthAnchor = new
        new.isActive = true

        lastSize.send(.init(width: sender.width, height: sender.height))
        resizeButtons.forEach { button in
            sender == button ? button.selectButton() : button.deselectButton()
        }

        UIView.animate(withDuration: 0.5, delay: 0) { [unowned self] in
            
            let height = ScreenSize.width * 0.8 * (sender.height / sender.width)

            if height > ScreenSize.height * 0.5 {
                
                imageHeightAnchor.isActive = false
                let newh = scrollView.heightAnchor.constraint(equalToConstant: ScreenSize.height * 0.5)
                imageHeightAnchor = newh
                newh.isActive = true
                
                imageWidthAnchor.isActive = false
                let new = scrollView.widthAnchor.constraint(equalToConstant: ScreenSize.height * 0.5 / (sender.height / sender.width))
                imageWidthAnchor = new
                new.isActive = true
                
                imageContainerRef.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
                imageContainerRef.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true

                return
            }
            
            imageWidthAnchor.isActive = false
            let neww = scrollView.widthAnchor.constraint(equalToConstant: ScreenSize.width * 0.8 )
            imageWidthAnchor = neww
            neww.isActive = true
            
            imageHeightAnchor.isActive = false
            let new = scrollView.heightAnchor.constraint(equalToConstant: ScreenSize.width * 0.8 * (sender.height / sender.width))
            imageHeightAnchor = new
            new.isActive = true
            
            imageContainerRef.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            imageContainerRef.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        }
    }
    
    @objc func didTapFilter(_ sender: FilterButton) {
        UIImpactFeedbackGenerator().impactOccurred()
        filterButtons.forEach { button in
            sender == button ? button.selectButton() : button.deselectButton()
        }
        
        if sender.filterName == "none" {
            imageView.image = viewModel.image.resize(to: .init(width: 1000, height: 1000), for: .scaleAspectFit)
            return
        }
        
        let context = CIContext(options: nil)
        guard let ciImage = CIImage(image: croppedImage) else { return}
        guard let filter = CIFilter(name: sender.filterName) else { return }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let output = filter.outputImage,
           let cgImage = context.createCGImage(output, from: output.extent) {
            let result = UIImage(cgImage: cgImage)
            var orientation: UIImage.Orientation = .up
            let image = UIImage(cgImage: cgImage, scale: viewModel.image.scale, orientation: orientation)
            imageView.image = image
        }

    }
}

extension EditViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        
        resizeButtons.forEach({$0.deselectButton()})
        cropViewController.dismiss(animated: true)

        
        let ratio = cropped.size.height / cropped.size.width
        
        let height = ScreenSize.width * 0.8 * ratio

        if height > ScreenSize.height * 0.5 {
            imageHeightAnchor.isActive = false
            let newh = scrollView.heightAnchor.constraint(equalToConstant: ScreenSize.height * 0.5)
            imageHeightAnchor = newh
            newh.isActive = true
            
            imageWidthAnchor.isActive = false
            let new = scrollView.widthAnchor.constraint(equalToConstant: ScreenSize.height * 0.5 / ratio)
            imageWidthAnchor = new
            new.isActive = true
            
            imageContainerRef.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            imageContainerRef.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true

            return
        }
        
        imageView.image = cropped
        croppedImage = cropped
        
        
        imageWidthAnchor.isActive = false
        let neww = scrollView.widthAnchor.constraint(equalToConstant: ScreenSize.width * 0.8)
        imageWidthAnchor = neww
        neww.isActive = true
        
        imageHeightAnchor.isActive = false
        let new = scrollView.heightAnchor.constraint(equalToConstant: ScreenSize.width * 0.8 * ratio)
        imageHeightAnchor = new
        new.isActive = true
        
        imageContainerRef.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        imageContainerRef.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true

        
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true)
    }
    
    
}

