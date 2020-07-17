//
//  InvoiceStatusViewController.swift
//  PIMPAY KASSA LLC, support@pikassa.io
//
//  Created by pikassa on 02.07.2020.
//

import UIKit


class InvoiceStatusViewController: UIViewController {
    @IBOutlet private weak var topBarView: TopBarView!
    @IBOutlet private weak var statusImageView: UIImageView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var orderNumberLabel: UILabel!
    @IBOutlet private weak var sumLabel: UILabel!
    @IBOutlet private weak var newOrderButton: Button!

    var uuid: String!
    var sum: Float!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.topBarView.setLeftButtonHidden(true)

        self.orderNumberLabel.text = self.uuid
        self.sumLabel.text = String(format: "%.2f Р", self.sum)

        self.newOrderButton.setStyle(.bordered)

        let timer: Timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] (timer: Timer) in
            self?.updateInvoiceStatus()
        }
        timer.fire()

        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    private func updateInvoiceStatus() {
        let req: OrderStatusRequest = OrderStatusRequest(invoiceUUID: self.uuid)
        req.perform { [weak self] (result: Result<OrderStatusResponse>) in
            switch result {
            case .success(let response):
                self?.statusLabel.text = ((response.status.code == 3) ? "Заказ успешно оплачен" : "Ошибка проведения платежа")
                self?.statusLabel.textColor = ((response.status.code == 3) ? UIColor.successGreen() : UIColor.errorRed())
                self?.statusImageView.image = ((response.status.code == 3) ? UIImage(named: "paymentSuccess") : UIImage(named: "paymentFailed"))
                break
            case .fail(let error):
                self?.statusLabel.text = "Ошибка получения статуса заказа"
                self?.statusLabel.textColor = UIColor.black
                self?.statusImageView.image = UIImage(named: "paymentFailed")
                self?.presentAlert(title: "Error", message: error.localizedDescription, action: nil)
            }
        }
    }

    @IBAction private func didTapNewOrderButton(_ sender: Any) {
        self.navigationController?.setViewControllers([QuantityViewController()], animated: true)
    }
}
