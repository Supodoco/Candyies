//
//  SectionHeader.swift
//  Candyies
//
//  Created by Supodoco on 09.09.2022.
//

import UIKit

class CatalogSectionHeader: UICollectionReusableView {
    
    static let identifier = "SectionHeader"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        labelConfigure()
        labelMakeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func labelConfigure() {
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    private func labelMakeConstraints() {
        addSubview(label)
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    }
}
