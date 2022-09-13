//
//  Gallery.swift
//  Candyies
//
//  Created by Supodoco on 04.09.2022.
//

import UIKit

class Gallery: UIViewController {
    
    private var collectionImages: UICollectionView?
    var images = (1...15).map { UIImage(named: "img\($0)") }
    let detailView = UIView()
    let img = UIImageView()
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialLight))

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images += images
        images.removeLast()
        
        collectionImagesConfigure()
        blurEffectViewConfigure()
        detailViewConfigure()
        
    }
    
    func collectionImagesConfigure() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 1
        if view.frame.width > 800 {
            layout.itemSize = CGSize(width: (view.frame.width / 4) - 6, height: (view.frame.width / 4) - 6)
        } else {
            layout.itemSize = CGSize(width: (view.frame.width / 3) - 4, height: (view.frame.width / 3) - 4)
        }
        collectionImages = UICollectionView(frame: .zero, collectionViewLayout: layout)

        guard let collectionImages = collectionImages else { return }
        collectionImages.register(GalleryCustomCell.self, forCellWithReuseIdentifier: GalleryCustomCell.identifier)
        collectionImages.dataSource = self
        collectionImages.delegate = self
        collectionImages.showsVerticalScrollIndicator = false
        view.addSubview(collectionImages)
        collectionImages.frame = view.bounds
    }
    func blurEffectViewConfigure() {
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(blurEffectView)
    }
    func detailViewConfigure() {
        detailView.backgroundColor = .white
        detailView.layer.cornerRadius = 8
        view.addSubview(detailView)
        detailView.addSubview(img)
    }
    
    @objc func longTapGesture(sender: UILongPressGestureRecognizer) {
        func viewDisappear() {
            img.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
            detailView.frame = CGRect(
                x: view.frame.width / 2,
                y: view.frame.height / 2,
                width: 1,
                height: 1
            )
        }
        if sender.state == .began {
            print("began")
            let position = sender.location(in: collectionImages)
            if let indexPath = collectionImages?.indexPathForItem(at: position) {
                img.image = images[indexPath.row]
            }
            
            viewDisappear()
            
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.blurEffectView.alpha = 0.95
                
                let height = self.view.frame.height / 7 * 4
                let width = height / 16 * 11
                self.detailView.frame = CGRect(
                    x: (self.view.frame.width - width) / 2,
                    y: (self.view.frame.height - height) / 2,
                    width: width,
                    height: height
                )
                let y: CGFloat = 20
                self.img.frame = CGRect(
                    x: 0,
                    y: y,
                    width: self.detailView.frame.width,
                    height: self.detailView.frame.height - 2 * y
                )
            }
        } else if sender.state == .ended {
            print("End")
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.blurEffectView.alpha = 0
                viewDisappear()
            }
        }
    }
}

extension Gallery: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionImages?.dequeueReusableCell(withReuseIdentifier: GalleryCustomCell.identifier, for: indexPath) as? GalleryCustomCell else { return UICollectionViewCell() }
        
        cell.imageView.image = images[indexPath.row]

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapGesture(sender:)))
        gesture.minimumPressDuration = 0.3
        cell.addGestureRecognizer(gesture)
        
        return cell
    }
    
}
