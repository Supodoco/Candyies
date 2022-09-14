//
//  GalleryCustomCell.swift
//  Candyies
//
//  Created by Supodoco on 05.09.2022.
//

import UIKit

class CatalogCustomCell: UICollectionViewCell {
    static let identifier = "CatalogCustomCell"

     
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.backgroundColor = .systemGray
        return image
    }()
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 7
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        return view
    }()
    let nameOfItem: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    let weightOfItem: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    var buttonPrice = UIButton()
    var buttonMinus = UIButton()
    var buttonPlus = UIButton()
    
    func buttonConfigure(_ button: UIButton, setTitle: String) -> UIButton {
        button.backgroundColor = .white
        button.setTitle(setTitle, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 7
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = .zero
        return button
    }
    
    
    let labelCounter = UILabel()
    
    let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 8
        return view
    }()
    let loadingViewSecond: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 8
        return view
    }()
    
    let desriptionData: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backView)
        
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameOfItem)
        
        contentView.addSubview(weightOfItem)
        
        contentView.addSubview(buttonPrice)
        contentView.addSubview(buttonMinus)
        contentView.addSubview(buttonPlus)
        contentView.addSubview(labelCounter)
        
        contentView.addSubview(loadingView)
        contentView.addSubview(loadingViewSecond)
        
    }
    func configure(image: UIImage, name: String, weight: Int, amount: Int, description: String) {
        imageView.image     = image
        nameOfItem.text     = name
        weightOfItem.text   = "\(weight) г"
        labelCounter.text   = String(amount)
        desriptionData.text = description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        backView.frame       = CGRect(x: 10,
                                      y: 10,
                                      width: contentView.frame.width - 20,
                                      height: contentView.frame.height - 20)
        
        imageView.frame      = CGRect(x: 20,
                                      y: 20,
                                      width: contentView.frame.width - 40,
                                      height: contentView.frame.width - 40)
        nameOfItem.frame     = CGRect(x: 20,
                                      y: contentView.frame.width,
                                      width: contentView.frame.width - 40,
                                      height: 20)
        weightOfItem.frame   = CGRect(x: 20,
                                      y: contentView.frame.width + 20,
                                      width: contentView.frame.width - 40,
                                      height: 20)
        buttonPrice.frame    = CGRect(x: 20,
                                      y: contentView.frame.width + 20 + 30,
                                      width: contentView.frame.width - 40,
                                      height: 40)
        buttonMinus.frame    = CGRect(x: 20,
                                      y: contentView.frame.width + 20 + 30,
                                      width: 40,
                                      height: 40)
        buttonPlus.frame     = CGRect(x: contentView.frame.width - 20 - 40,
                                      y: contentView.frame.width + 20 + 30,
                                      width: 40,
                                      height: 40)
        
        labelCounter.translatesAutoresizingMaskIntoConstraints = false
        labelCounter.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        labelCounter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        
        loadingView.frame          = CGRect(x: 20,
                                      y: contentView.frame.width + 20 + 30,
                                      width: contentView.frame.width - 40,
                                      height: 40)
        loadingViewSecond.frame    = CGRect(x: 20,
                                      y: contentView.frame.width,
                                      width: contentView.frame.width - 40,
                                      height: 40)
    }
}
