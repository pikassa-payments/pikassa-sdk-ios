//
//  QuantityViewController.swift
//  PIMPAY KASSA LLC, support@pikassa.io
//
//  Created by pikassa on 02.07.2020.
//

import UIKit


class QuantityViewController: UIViewController {
    @IBOutlet private weak var topBar: TopBarView!
    @IBOutlet private weak var countTextField: TextField!
    @IBOutlet private weak var buyButton: UIButton!
    @IBOutlet private weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.topBar.setLeftButtonHidden(true)

        self.countTextField.setTitle("Количество товаров в штуках")
        self.countTextField.setKeyboardType(.numberPad)
        self.countTextField.formatter = LimitedCharactersTextFieldFormatter(limit: 5)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func routeToCardDetails(invoiceUUID: String, orderId: String, redirectURLs: [URL], sum: Float) {
        let cardDetailsVC: CardDetailsViewController = CardDetailsViewController()
        cardDetailsVC.invoiceId = invoiceUUID
        cardDetailsVC.orderId = orderId
        cardDetailsVC.redirectURLs = redirectURLs
        cardDetailsVC.sum = sum
        self.navigationController?.pushViewController(cardDetailsVC, animated: true)
    }

    @IBAction func didTapBuyButton(_ sender: Any) {
        guard let text: String = self.countTextField.text(), let count: Int = Int(text), count > 0 else {
            self.countTextField.setError("Введите количество товаров")
            return
        }

        let request: CreateOrderRequest = CreateOrderRequest(data: OrderRequest(items: [OrderRequest.Item(code: 1, count: count)], customerPhone: "+79999999999", customerEmail: "mail@example.com"))
        request.perform { [weak self] (result: Result<CreateOrderResponse>) in
            switch result {
            case .success(let response):
                var urls: [URL] = []
                
                if let successURL: URL = URL(string: response.successUrl) {
                    urls.append(successURL)
                }

                if let failURL: URL = URL(string: response.failUrl) {
                    urls.append(failURL)
                }

                self?.routeToCardDetails(invoiceUUID: response.invoiceUuid, orderId: response.uuid, redirectURLs: urls, sum: response.items.first?.amount ?? 0.0)
            case .fail(let error):
                self?.presentAlert(title: "Ошибка", message: error.localizedDescription, action: nil)
                break
            }
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
