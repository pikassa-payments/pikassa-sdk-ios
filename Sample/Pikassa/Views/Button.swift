//
//  Button.swift
//  Pikassa
//
//  Created by pikassa on 10.07.2020.
//  Copyright © 2020 PIMPAY KASSA LLC. All rights reserved.
//

import UIKit


class Button: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.setUp()
    }

    private func setUp() {
        self.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 14.0)
        self.layer.cornerRadius = 4.0

        self.setStyle(.solid)
    }

    func setStyle(_ style: Style) {
        switch style {
        case .solid:
            self.backgroundColor = UIColor.accentBlue()
            self.titleLabel?.textColor = UIColor.white
        case .bordered:
            self.backgroundColor = UIColor.white
            self.titleLabel?.textColor = UIColor.accentBlue()
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.accentBlue().cgColor
        }
    }

    enum Style {
        case solid
        case bordered
    }
}
