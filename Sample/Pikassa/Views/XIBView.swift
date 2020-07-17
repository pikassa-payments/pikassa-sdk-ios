//
//  XIBView.swift
//  Pikassa
//
//  Created by pikassa on 10.07.2020.
//  Copyright © 2020 PIMPAY KASSA LLC. All rights reserved.
//

import UIKit


class XIBView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.loadXIB()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    self.loadXIB()
  }

  func loadXIB() {
    guard let view: UIView = Bundle.main.loadNibNamed(NSStringFromClass(type(of: self)).components(separatedBy: ".").last!,
                                                      owner: self,
                                                      options: nil)?[0] as? UIView else {
      fatalError("can't load view")
    }

    view.translatesAutoresizingMaskIntoConstraints = false;
    self.addSubview(view)

    self.addConstraints([
      view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      view.topAnchor.constraint(equalTo: self.topAnchor),
      view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
}
