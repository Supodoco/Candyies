//
//  Extension + UIButton.swift
//  Candyies
//
//  Created by Supodoco on 14.10.2022.
//

import UIKit

extension UIButton {
    func buttonConfigure(setTitle: String) {
        self.backgroundColor = .white
        self.setTitle(setTitle, for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = .zero
    }
}
