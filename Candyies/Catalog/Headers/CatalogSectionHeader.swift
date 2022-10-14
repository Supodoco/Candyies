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
    let editButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        labelConfigure()
        labelMakeConstraints()
        editButtonConfigure()
        editButtonMakeConstraints()
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
        label.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func editButtonConfigure() {
        let configureImage = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold, scale: .medium)
        let image = UIImage(named: "plus.viewfinder", in: nil, with: configureImage)?
            .withTintColor(.black)
            .withRenderingMode(.alwaysOriginal)
            
    
        editButton.setImage(image, for: .normal)
        editButton.translatesAutoresizingMaskIntoConstraints = false
    }
    private func editButtonMakeConstraints() {
        addSubview(editButton)
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30)
        
        ])
        

    }
}
