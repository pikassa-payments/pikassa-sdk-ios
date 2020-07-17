//
//  RoundedCornersView.swift
//  Pikassa
//
//  Created by pikassa on 10.07.2020.
//  Copyright © 2020 PIMPAY KASSA LLC. All rights reserved.
//

import UIKit


class RoundedCornersView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()

        let path: UIBezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 4.0, height: 4.0))
        let mask: CAShapeLayer = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
