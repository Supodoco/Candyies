//
//  DetailItemController.swift
//  Candyies
//
//  Created by Supodoco on 14.09.2022.
//

import UIKit

class DetailItemController: UIViewController {
    var image = UIImageView()
    var labelTitle = UILabel()
    var labelDescription = UILabel()
    let buttonEdit = UIButton()
    let buttonPrice = UIButton()
    var cellData: CatalogModel!
    
    init(cellData: CatalogModel) {
        super.init(nibName: nil, bundle: nil)
        self.cellData = cellData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = cellData.image
        
        let description = cellData.description.count > 0 ? "· " + cellData.description : ""
        labelDescription.text = String(cellData.weight) + " г " + description
        
        labelTitle.text = cellData.title
        
        view.backgroundColor = .white
        viewsConfigure()
        viewsMakeConstraints()
        
        buttonEdit.isHidden = isAdminViewModel.shared.admin ? false : true
        buttonEdit.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        buttonPrice.buttonConfigure(setTitle: "Добавить в корзину - \(cellData.price) ₽")
    }

    @objc private func editButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editScreen = storyboard.instantiateViewController(
            withIdentifier: "AppendToCatalogViewController") as? AppendToCatalogViewController
        else { return }
        editScreen.cellData = cellData

        present(editScreen, animated: true)
    }
    
    func viewsConfigure() {
        labelTitle.textColor = .black
        labelTitle.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        labelTitle.numberOfLines = 2
        
        labelDescription.font = UIFont.systemFont(ofSize: 15, weight: .light)
        
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        buttonEdit.backgroundColor = .white
        let configureImage = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold, scale: .medium)
        let image = UIImage(systemName: "pencil.circle")?
            .withTintColor(.black)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(configureImage)
        buttonEdit.setImage(image, for: .normal)
        buttonEdit.layer.cornerRadius = 8
        
    }
    
    func viewsMakeConstraints() {
        image.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        buttonEdit.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        buttonPrice.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(image)
        view.addSubview(labelTitle)
        view.addSubview(buttonEdit)
        view.addSubview(labelDescription)
        view.addSubview(buttonPrice)

        NSLayoutConstraint.activate([
            
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            buttonEdit.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -10),
            buttonEdit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonEdit.widthAnchor.constraint(equalToConstant: 40),
            buttonEdit.heightAnchor.constraint(equalToConstant: 40),
            
            labelTitle.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            labelDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            labelDescription.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelDescription.trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),
            
            buttonPrice.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            buttonPrice.trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),
            buttonPrice.heightAnchor.constraint(equalToConstant: 50),
            buttonPrice.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            
            
        
        ])
    }
}
