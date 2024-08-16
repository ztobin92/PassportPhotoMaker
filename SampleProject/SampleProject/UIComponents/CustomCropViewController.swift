//
//  CustomCropViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 20.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import UIKit
import Combine
import Mantis

public enum Metric: String {
    case inch, mm, cm
    
    var ID: String {
        switch self {
        case .inch:
            return "in"
        case .mm:
            return "mm"
        case .cm:
            return "cm"
        }
    }
}

var lastMetric = CurrentValueSubject<Metric, Never>(.inch)
var lastSize = CurrentValueSubject<CGSize, Never>(.init(width: 2, height: 2))


class CustomCropViewController: CropViewController {
    let unitPickerView = UIPickerView()
    var cancellable = Set<AnyCancellable>()
    var source: [Metric] = [.inch, .mm, .cm]
    
    let heightTextField = UITextFieldBuilder()
        .cornerRadius(8)
        .placeholder("Height")
        .text("2")
        .leftView(.init(frame: .init(x: 0, y: 0, width: 5, height: 0)), viewMode: .always)
        .backgroundColor(.lightGray.withAlphaComponent(0.2))
        .build()
    
    let widthTextField = UITextFieldBuilder()
        .cornerRadius(8)
        .leftView(.init(frame: .init(x: 0, y: 0, width: 5, height: 0)), viewMode: .always)
        .placeholder("Width")
        .text("2")
        .backgroundColor(.lightGray.withAlphaComponent(0.2))
        .build()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cropToolbar.delegate?.didSelectRatio(cropToolbar, ratio: 1)
        
        let titleLabel = UILabelBuilder()
            .text("Custom Size")
            .backgroundColor(.white)
            .textAlignment(.center)
            .font(.systemFont(ofSize: 17, weight: .semibold))
            .build()
        titleLabel.withHeight(45)
        
        stackView?.insertArrangedSubview(titleLabel, at: 0)
        
        let inputContainer = UIView()
        
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        unitPickerView.isHidden = true
        unitPickerView.withHeight(100)
        
        widthTextField.keyboardType = .decimalPad
        widthTextField.delegate = self
        
        heightTextField.keyboardType = .decimalPad
        heightTextField.delegate = self
        
        widthTextField.addTarget(self, action: #selector(textDidChange), for: .allEditingEvents)
        heightTextField.addTarget(self, action: #selector(textDidChange), for: .allEditingEvents)

        inputContainer.stack(
            prepareUnitCell(field: widthTextField),
            prepareUnitCell(field: heightTextField),
            spacing: 10,
            distribution: .fillEqually
        )
        .withMargins(.allSides(10))
        .withHeight(ScreenSize.height * 0.13)
        
        cropStackView.addArrangedSubview(inputContainer)
        cropStackView.addArrangedSubview(unitPickerView)
        
    }
    
    private func prepareUnitCell(field: UITextField) -> UIView {
        
        let label = UILabelBuilder()
            .text("\(field.placeholder ?? "")\t:")
            .textAlignment(.center)
            .font(.systemFont(ofSize: 14))
            .textColor(.lightGray)
            .build()
        
        let pickerContainerLabel = UILabel(text: "inch", font: .systemFont(ofSize: 14), textAlignment: .center)
        
        lastMetric.sink { metric in
            pickerContainerLabel.text = metric.rawValue
        }.store(in: &cancellable)
        
        field.placeholder = nil
        
        let pickerContainer = HighlightedView()
        pickerContainer.layer.cornerRadius = 8
        pickerContainer.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        pickerContainer.onTap { [weak self] in
            UIView.animate(withDuration: 0.5, delay: 0) {
                self?.unitPickerView.isHidden.toggle()
            }
        }
        
        let dropImage = UIImageView(image: .init(systemName: "arrowtriangle.down.fill")!, contentMode: .scaleAspectFit)
        dropImage.tintColor = .black
        
        pickerContainer.stack(
            pickerContainer.hstack(
                pickerContainerLabel,
                dropImage.withWidth(13),
                spacing: 5
            ),
            alignment: .center
        )
        
        return view.hstack(
            label.withWidth(100),
            field,
            pickerContainer.withWidth(60),
            spacing: 10
        )
    }
}

extension CustomCropViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textDidChange() {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current // Yerel ayarlara göre biçimlendirme yapar
        
        guard
            let widthText = widthTextField.text,
            let width = numberFormatter.number(from: widthText)?.doubleValue,
            let heightText = heightTextField.text,
            let height = numberFormatter.number(from: heightText)?.doubleValue,
            width > 0,
            height > 0
        else { return }

        lastSize.send(.init(width: width, height: height))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.cropToolbar.delegate?.didSelectRatio(self.cropToolbar, ratio: width / height)
        }
    }
}

extension CustomCropViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // PickerView için sütun sayısını döndür
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // PickerView için satır sayısını döndür
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return source.count // İnch, cm, mm, diğer birimler
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            self?.unitPickerView.isHidden.toggle()
            lastMetric.send(self?.source[row] ?? .inch)
        }
    }
    
    // PickerView için satır içeriğini döndür
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        source[row].rawValue
    }
}
