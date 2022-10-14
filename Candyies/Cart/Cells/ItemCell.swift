//
//  CartCell.swift
//  Candyies
//
//  Created by Supodoco on 06.09.2022.
//

import UIKit

class ItemCell: UITableViewCell {
    static let identifier = "ItemCell"
    var image: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 8
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    var labelName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    let labelCost: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    let viewBack: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 7
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        return view
    }()
    var buttonsMinus = UIButton()
    var buttonCounter = UIButton()
    var buttonPlus = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        contentView.addSubview(viewBack)
        contentView.addSubview(image)
        contentView.addSubview(labelName)
        contentView.addSubview(labelCost)
        
        contentView.addSubview(buttonsMinus)
        contentView.addSubview(buttonCounter)
        contentView.addSubview(buttonPlus)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        viewBack.frame  = CGRect(x: 7, y: 7, width: contentView.frame.width - 14, height: contentView.frame.height - 14)
        image.frame     = CGRect(x: 13, y: 13, width: contentView.frame.height - 26, height: contentView.frame.height - 26)
        
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelCost.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            labelCost.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13),
            labelCost.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            labelCost.widthAnchor.constraint(equalToConstant: 80),
            
            labelName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentView.frame.height),
            labelName.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            labelName.trailingAnchor.constraint(equalTo: labelCost.leadingAnchor)
            
            
        ])
        let blockHeight: CGFloat = 67
        let size: CGFloat = 45
        buttonsMinus.frame = CGRect(x: contentView.frame.height, y: blockHeight, width: size, height: size)
        buttonCounter.frame = CGRect(x: contentView.frame.height + size, y: blockHeight, width: size, height: size)
        buttonPlus.frame = CGRect(x: contentView.frame.height + size * 2, y: blockHeight, width: size, height: size)
    }
}
