//
//  TopBarView.swift
//  Pikassa
//
//  Created by pikassa on 10.07.2020.
//  Copyright © 2020 PIMPAY KASSA LLC. All rights reserved.
//

import UIKit


class TopBarView: XIBView {
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!

    var didTapLeftButtonBlock: (() -> Void)?

    func setTitle(_ title: String?) {
        self.titleLabel.text = title
    }

    func setLeftButtonHidden(_ hidden: Bool) {
        self.leftButton.isHidden = hidden
    }

    @IBAction func didTapLeftButton(_ sender: Any) {
        self.didTapLeftButtonBlock?()
    }
}
