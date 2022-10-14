//
//  InfoCell.swift
//  Candyies
//
//  Created by Supodoco on 06.09.2022.
//

import UIKit

class BuyCell: UITableViewCell {

    static let identifier = "InfoCell"
    
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    let labelCost: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    let button: UIView = {
        let button = UIView()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        return button
    }()
    
    func buttonConfigure(_ color: UIColor) {
        if color == .white {
            label.text = "Доставка"
            button.backgroundColor = .white
            labelCost.textColor = .black
            label.textColor = .black
        } else {
            label.text = "Оформить заказ"
            button.backgroundColor = .systemGreen
            labelCost.textColor = .white
            label.textColor = .white
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        contentView.addSubview(button)
        button.addSubview(label)
        button.addSubview(labelCost)
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        label.translatesAutoresizingMaskIntoConstraints = false
        labelCost.translatesAutoresizingMaskIntoConstraints = false
        
        button.frame = CGRect(x: 10, y: 10, width: contentView.frame.width - 20, height: 50)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        
            labelCost.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            labelCost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        
        
    }

}
