//
//  Networking.swift
//  Candyies
//
//  Created by Supodoco on 07.09.2022.
//

import Foundation
import UIKit

extension Catalog {
    
    func loadImage(_ url: String, _ closure: @escaping (UIImage) -> ())  {
        guard let url = URL(string: url) else { return }
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                print("--- = \(imageData)")
                if let loadedImage = UIImage(data: imageData) {
                    print("--- == Image")
                    closure(loadedImage)
                }
            }
        }
    }
    
    func loadData(_ section: Int, url: String, closure: @escaping () -> ()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            guard let data = data else { return }
            print(data)
            do {
                let catalog = try JSONDecoder().decode([LoadingModel].self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    let id: Int = section == 0 ? 0 : 50
                    for (index, candy) in catalog.enumerated() {
                        if candy.image.hasPrefix("http") {
                            print(candy.image)
                            print("--- Find URL")
                            
                            self.loadImage(candy.image) { image in
                                print("--- === Unwrap Success")
                                Singleton.shared.data[id + index] = CatalogModel(
                                    image: image,
                                    name: candy.name,
                                    weight: candy.weight,
                                    price: candy.price,
                                    amount: 0,
                                    description: candy.description
                                )
                            }
                        } else {
                            print("--- Find image")
                            if let image = UIImage(named: candy.image) {
                                Singleton.shared.data[id + index] = CatalogModel(
                                    image: image,
                                    name: candy.name,
                                    weight: candy.weight,
                                    price: candy.price,
                                    amount: 0,
                                    description: candy.description
                                )
                            }
                        }
                    }
                    closure()
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
}
