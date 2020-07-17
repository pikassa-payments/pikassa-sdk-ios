//
//  UIViewController+AlertController.swift
//  PIMPAY KASSA LLC, support@pikassa.io
//
//  Created by pikassa on 02.07.2020.
//

import Foundation
import UIKit


extension UIViewController {
    func presentAlert(title: String?, message: String?, action: (() -> Void)?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: action)
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
