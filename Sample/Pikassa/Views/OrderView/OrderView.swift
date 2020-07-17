//
//  OrderView.swift
//  Pikassa
//
//  Created by pikassa on 10.07.2020.
//  Copyright © 2020 PIMPAY KASSA LLC. All rights reserved.
//

import UIKit


class OrderView: XIBView {
    @IBOutlet private weak var titleLabel: UILabel!

    func setTitle(_ title: String?) {
        self.titleLabel.text = title
    }
}
