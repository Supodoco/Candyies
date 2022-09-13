//
//  GalleryCustomCell.swift
//  Candyies
//
//  Created by Supodoco on 04.09.2022.
//

import UIKit

class GalleryCustomCell: UICollectionViewCell {
    
    static let identifier = "GalleryCustomCell"
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: contentView.frame.width,
                                 height: contentView.frame.width)
    }
}
