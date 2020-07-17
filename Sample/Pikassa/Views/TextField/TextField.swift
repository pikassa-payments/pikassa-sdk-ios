//
//  TextField.swift
//  Pikassa
//
//  Created by pikassa on 10.07.2020.
//  Copyright © 2020 PIMPAY KASSA LLC. All rights reserved.
//

import Foundation
import UIKit


class TextField: XIBView, UITextFieldDelegate {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!

    private let errorColor: UIColor = UIColor.errorRed()
    private let normalColor: UIColor = UIColor.underlineNormal()
    private let activeColor: UIColor = UIColor.accentBlue()
    private var placeholder: NSAttributedString?

    var shouldChangeCharactersInRangeBlock: ((TextField, NSRange, String) -> Bool)?
    var formatter: TextFieldFormatterProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.setUp()
    }

    private func setUp() {
        self.textField.delegate = self
        self.titleLabel.isHidden = true

        self.setTitle(nil)
        self.setError(nil)

        self.lineView.backgroundColor = UIColor.clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let path: UIBezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 4.0, height: 4.0))
        let mask: CAShapeLayer = CAShapeLayer()
        mask.path = path.cgPath
        self.containerView.layer.mask = mask
    }

    func setTitle(_ title: String?) {
        self.titleLabel.text = title

        if let title = title {
            self.placeholder = NSAttributedString(string: title, attributes: [
                .font: UIFont(name: "Roboto-Regular", size: 16.0)!,
                .foregroundColor: UIColor.textGray()])
        } else {
            self.placeholder = nil
        }

        self.textField.attributedPlaceholder = self.placeholder
    }

    func setSecure(_ secure: Bool) {
        self.textField.isSecureTextEntry = secure
    }

    func setKeyboardType(_ type: UIKeyboardType) {
        self.textField.keyboardType = type
    }

    func setError(_ error: String?) {
        UIView.animate(withDuration: 0.1) {
            self.errorLabel.text = error
            self.titleLabel.textColor = ((error != nil) ? self.errorColor : self.normalColor)
            self.errorLabel.alpha = ((error != nil) ? 1.0 : 0.0)
            self.lineView.backgroundColor = ((error != nil) ? self.errorColor : self.normalColor)
        }
    }

    func text() -> String? {
        return ((self.formatter != nil) ? self.formatter?.unformattedValue(self.textField.text) : self.textField.text)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            self.titleLabel.isHidden = false
            self.textField.attributedPlaceholder = nil
            self.setError(nil)
            self.lineView.backgroundColor = self.activeColor
        }

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            if (textField.text?.count ?? 0) == 0 {
                self.titleLabel.isHidden = true
                self.textField.attributedPlaceholder = self.placeholder
            } else {
                self.titleLabel.isHidden = false
            }
            self.lineView.backgroundColor = UIColor.clear
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.shouldChangeCharactersInRangeBlock?(self, range, string) ?? true
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        if let formatter: TextFieldFormatterProtocol = self.formatter {
            self.textField.text = formatter.format(value: self.textField.text)
        }
    }
}


protocol TextFieldFormatterProtocol {
    func format(value: String?) -> String?
    func unformattedValue(_ value: String?) -> String?
}


class TextFieldCardNumberFormatter: TextFieldFormatterProtocol {
    func format(value: String?) -> String? {
        guard var value: String = value?.replacingOccurrences(of: " ", with: "") else {
            return nil
        }

        if value.count >= 19 {
            value = String(value.prefix(19))
        }

        var formattedValue: String = ""
        let chars: [Character] = Array(value)

        for (i, c) in chars.enumerated() {
            formattedValue.append(c)

            if(((i + 1) % 4 == 0) && (i + 1 != chars.count)){
                formattedValue.append(" ")
            }
        }

        return formattedValue
    }

    func unformattedValue(_ value: String?) -> String? {
        return value?.replacingOccurrences(of: " ", with: "")
    }
}


class TextFieldCardExpiryDateFormatter: TextFieldFormatterProtocol {
    func format(value: String?) -> String? {
        guard let value: String = value else {
            return nil
        }

        if value.count > 7 {
            return String(value.prefix(7))
        }

        if value.count == 4 {
            return String(value.prefix(2))
        }

        let clearValue: String = value.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: " ", with: "")
        var newValue: String = ""

        for (index, c) in clearValue.enumerated() {
            if index == 1 {
                newValue = "\(newValue)\(c) / "
            } else {
                newValue.append(c)
            }
        }

        return newValue
    }

    func unformattedValue(_ value: String?) -> String? {
        return value
    }
}


class LimitedCharactersTextFieldFormatter: TextFieldFormatterProtocol {
    let limit: Int

    init(limit: Int) {
        self.limit = limit
    }


    func format(value: String?) -> String? {
        guard let value: String = value else {
            return nil
        }

        if value.count > self.limit {
            return String(value.prefix(self.limit))
        }

        return value
    }

    func unformattedValue(_ value: String?) -> String? {
        guard let value: String = value else {
            return nil
        }

        return String(value.prefix(self.limit))
    }
}
