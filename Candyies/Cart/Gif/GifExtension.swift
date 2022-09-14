//
//  GifExtension.swift
//  Candyies
//
//  Created by Supodoco on 14.09.2022.
//

import UIKit

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
              let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}


//guard let confettiImageView = UIImageView.fromGif(frame: CGRect(x: 30, y: 30, width: 200, height: 200), resourceName: "hungry") else { return }
//view.addSubview(confettiImageView)
//confettiImageView.animationDuration = 3
//confettiImageView.animationRepeatCount = 1
//confettiImageView.startAnimating()
