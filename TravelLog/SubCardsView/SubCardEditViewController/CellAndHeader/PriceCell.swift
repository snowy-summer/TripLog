//
//  PriceCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/08.
//

import UIKit

final class PriceCell: UICollectionViewCell {
    
    private let priceTextField = UITextField()
    private let swapCurrencyButton = UIButton()
    private let mainqueue = DispatchQueue.main
    
    weak var delegate: PriceViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCurrencyButton()
        configurePriceTextField()
        mainqueue.async {
            self.configureUnderLine(size: 2,
                                    color: UIColor.lightGray.cgColor)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Method

extension PriceCell {
    
    func updatePrice(price: Double?) {
        guard let price = price else { return }
        
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        let formattedNumber = numberFormmater.string(from: NSNumber(value: price))
        
        priceTextField.text = formattedNumber
    }

    func updateButtonTitle(text: String?) {
        
        swapCurrencyButton.setTitle(text,
                                    for: .normal)
    }
    
    @objc func didTextFieldChange() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let priceText = priceTextField.text else { return }
        
        var numWithoutComma = priceText.split(separator: ",").joined()
        let components = numWithoutComma.split(separator: ".",
                                               maxSplits: 2,
                                               omittingEmptySubsequences: false)
        
        if components.count > 2 {
            numWithoutComma.removeLast()
        } else if components.count == 2 && components[1].isEmpty {
            priceTextField.text = formatNumberString(numWithoutComma)
            return
        }
        
        guard let price = Double(numWithoutComma) else { return }
        let formattedNumber = numberFormatter.string(from: NSNumber(value: price))
        
        priceTextField.text = formattedNumber
        let textWithoutComma = formattedNumber?.split(separator: ",").joined()
        delegate?.updateViewModelValue(price: textWithoutComma)
    }

    func formatNumberString(_ text: String) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let components = text.split(separator: ".",
                                    maxSplits: 2,
                                    omittingEmptySubsequences: false)
        
        guard let firstPart = Double(components[0].split(separator: ",").joined()),
              let formattedFirstPart = numberFormatter.string(from: NSNumber(value: firstPart)) else { return nil }
        
        if components.count > 1 {
            return formattedFirstPart + "." + components[1]
        } else {
            return formattedFirstPart
        }
    }

    
    @objc func presentCurrencyRateList() {
        delegate?.presentCurrencyList()
    }
}

//MARK: - Configuration

extension PriceCell {
    
    private func configureCurrencyButton() {
        contentView.addSubview(swapCurrencyButton)
        
        swapCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        swapCurrencyButton.configuration = buttonConfiguration()
        var currentCurrency = UserDefaults.standard.object(forKey: "currentCurrency") as? String
        if currentCurrency == nil {
            UserDefaults.standard.set("KRW", forKey: "currentCurrency")
            currentCurrency = UserDefaults.standard.object(forKey: "currentCurrency") as? String
        }
        swapCurrencyButton.setTitle(currentCurrency,
                                    for: .normal)
        swapCurrencyButton.setTitleColor(.black,
                                         for: .normal)
        swapCurrencyButton.setImage(UIImage(systemName: "chevron.down"),
                                    for: .normal)
        swapCurrencyButton.addTarget(self,
                                     action: #selector(presentCurrencyRateList),
                                     for: .touchUpInside)
        
        let imageConstraints = [
            swapCurrencyButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: 4),
            swapCurrencyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                       constant: -4),
            swapCurrencyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            swapCurrencyButton.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                      multiplier: 0.3)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    private func buttonConfiguration() -> UIButton.Configuration {
        
        var configuration = UIButton.Configuration.bordered()
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .clear
        
        return configuration
    }
    
    private func configurePriceTextField() {
        contentView.addSubview(priceTextField)
        
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        priceTextField.textAlignment = .left
        priceTextField.font = .preferredFont(forTextStyle: .title3)
        priceTextField.placeholder = "금액을 입력하세요"
        priceTextField.keyboardType = .decimalPad
        priceTextField.addTarget(self,
                                 action: #selector(didTextFieldChange),
                                 for: .editingChanged)
        
        let textFieldConstraints = [
            priceTextField.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: 4),
            priceTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -4),
            priceTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            priceTextField.trailingAnchor.constraint(equalTo: swapCurrencyButton.leadingAnchor,
                                                     constant: -8)
        ]
        
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    
    private func configureUnderLine(size: CGFloat, color: CGColor?) {
        let underLine = CALayer()
        
        self.layer.addSublayer(underLine)
        
        underLine.backgroundColor = color
        
        underLine.frame = CGRect(origin: CGPoint(x: priceTextField.frame.origin.x,
                                                 y: self.frame.height),
                                 size: CGSize(width: priceTextField.frame.width,
                                              height: size))
        
    }
}



