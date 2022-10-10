//
//  DetailItemController.swift
//  Candyies
//
//  Created by Supodoco on 14.09.2022.
//

import UIKit

class DetailItemController: UIViewController {
    var image = UIImageView()
    var label = UILabel()
    let buttonEdit = UIButton()
    var cellData: CatalogModel!
    
    init(image: UIImage, label: String, cellData: CatalogModel) {
        super.init(nibName: nil, bundle: nil)
        self.image.image = image
        self.label.text = label
        self.cellData = cellData
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewsConfigure()
        viewsMakeConstraints()
        
        buttonEdit.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
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
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
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
        label.translatesAutoresizingMaskIntoConstraints = false
        buttonEdit.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(image)
        view.addSubview(label)
        view.addSubview(buttonEdit)
        
        
        
        NSLayoutConstraint.activate([
            
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonEdit.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -10),
            buttonEdit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonEdit.widthAnchor.constraint(equalToConstant: 40),
            buttonEdit.heightAnchor.constraint(equalToConstant: 40)
            
        
        ])
    }
}
