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

    override func viewDidLoad() {
        super.viewDidLoad()

        viewsConfigure()
        viewsMakeConstraints()

    }
    func viewsConfigure() {
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
    }
    
    func viewsMakeConstraints() {
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(image)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        
        ])
    }
}
