//
//  CardDetailsViewController.swift
//  PIMPAY KASSA LLC, support@pikassa.io
//
//  Created by pikassa on 02.07.2020.
//

import UIKit
import PikassaSDK

class CardDetailsViewController: UIViewController {
    @IBOutlet private weak var topBar: TopBarView!
    @IBOutlet private weak var panTextField: TextField!
    @IBOutlet private weak var cardHolderTextField: TextField!
    @IBOutlet private weak var expTextField: TextField!
    @IBOutlet private weak var cvcTextField: TextField!
    @IBOutlet private weak var payButton: UIButton!
    @IBOutlet private weak var containerBottomConstraint: NSLayoutConstraint!

    var invoiceId: String!
    var orderId: String!
    var redirectURLs: [URL] = []
    var sum: Float!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.topBar.didTapLeftButtonBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        self.panTextField.setTitle("Номер карты")
        self.panTextField.formatter = TextFieldCardNumberFormatter()
        self.panTextField.setKeyboardType(UIKeyboardType.numberPad)

        self.cardHolderTextField.setTitle("Имя и фамилия владельца карты")
        self.cardHolderTextField.setKeyboardType(UIKeyboardType.asciiCapable)

        self.expTextField.setTitle("Срок действия карты")
        self.expTextField.formatter = TextFieldCardExpiryDateFormatter()
        self.expTextField.setKeyboardType(UIKeyboardType.numberPad)

        self.cvcTextField.setTitle("CVV код")
        self.cvcTextField.formatter = LimitedCharactersTextFieldFormatter(limit: 3)
        self.cvcTextField.setKeyboardType(UIKeyboardType.numberPad)
        self.cvcTextField.setSecure(true)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)

        self.payButton.setTitle("ОПЛАТИТЬ \(String(format: "%.2f", self.sum)) Р", for: .init())
    }

    private func routeToInvoiceStatusScreen(invoiceUUID: String) {
        let vc: InvoiceStatusViewController = InvoiceStatusViewController()
        vc.uuid = invoiceUUID
        vc.sum = self.sum

        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func expDate() -> (mm: Int, yy: Int)? {
        guard let components: [String] = self.expTextField.text()?.components(separatedBy: "/"),
            components.count == 2,
            let mm: Int = Int(components[0].replacingOccurrences(of: " ", with: "")),
            let yy: Int = Int(components[1].replacingOccurrences(of: " ", with: "")) else {
            return nil
        }

        return (mm, yy)
    }

    @IBAction func didTapPayButton(_ sender: Any) {
        guard let pan: String = self.panTextField.text(), (pan.count >= 16 && pan.count <= 19) else {
            self.panTextField.setError("Неверный номер карты")
            return
        }

        self.panTextField.setError(nil)

        guard let cardHolder: String = self.cardHolderTextField.text(), cardHolder.count > 0 else {
            self.cardHolderTextField.setError("Владелец карты должен быть указан")
            return
        }

        self.cardHolderTextField.setError(nil)

        guard let expDate: (mm: Int, yy: Int) = self.expDate(),
            expDate.mm <= 12,
            let date: Date = DateComponents(calendar: Calendar(identifier: Calendar.Identifier.gregorian), year: expDate.yy + 2000, month: expDate.mm, day: 1).date,
            date > Date() else {

            self.expTextField.setError("Неверная дата")
            return
        }

        self.expTextField.setError(nil)

        guard let cvcStr: String = self.cvcTextField.text(), cvcStr.count == 3, let cvc: Int = Int(cvcStr) else {
            self.cvcTextField.setError("Введите CVV код")
            return
        }

        self.cvcTextField.setError(nil)

        let orderId: String = self.orderId

        let cardDetails: BankCardDetails = BankCardDetails(
            pan: pan,
            cardHolder: cardHolder,
            cvc: cvc,
            expYear: expDate.yy,
            expMonth: expDate.mm)
        
        Pikassa.shared.sendPaymentData(
            method: .bankCard(details: cardDetails),
            invoiceId: self.invoiceId,
            didSuccessBlock: { [weak self] (response: PayResponse) in
                if let redirectURLStr: String = response.redirect?.url, let redirectURL: URL = URL(string: redirectURLStr) {
                    let webViewVC: WebViewController = WebViewController()
                    webViewVC.url = redirectURL
                    webViewVC.redirectURLs = (self?.redirectURLs ?? [])
                    webViewVC.didDismissBlock = {
                        self?.routeToInvoiceStatusScreen(invoiceUUID: orderId)
                    }
                    
                    self?.present(webViewVC, animated: true, completion: nil)
                } else {
                    self?.routeToInvoiceStatusScreen(invoiceUUID: orderId)
                }
        }) { [weak self] (error: Error) in
            self?.presentAlert(title: "Ошибка", message: error.localizedDescription, action: nil)
        }
    }

    @objc
    private func _keyboardWillShow(notification: Notification) {
        if let frame: CGRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.containerBottomConstraint.constant = frame.height
        }
    }

    @objc
    private func _keyboardWillHide(notification: Notification) {
        self.containerBottomConstraint.constant = 0.0
    }
}
