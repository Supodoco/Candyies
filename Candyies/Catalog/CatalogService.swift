//
//  Networking.swift
//  Candyies
//
//  Created by Supodoco on 07.09.2022.
//

import Foundation
import UIKit

class CatalogService {
    let catalogVaporURL = "http://195.133.201.108/api/catalog"
    static let shared = CatalogService()
    private init() {}
    
    func loadImage(_ url: String, _ closure: @escaping (UIImage) -> ())  {
        guard let url = URL(string: url),
              let imageData = try? Data(contentsOf: url),
              let loadedImage = UIImage(data: imageData)
        else { return }
        print("--- = \(imageData)")
        print("--- == Image")
        closure(loadedImage)
    }
    
    func loadData(url: String, closure: @escaping () -> ()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            guard let data = data else { return }
            do {
                let catalog = try JSONDecoder().decode([LoadingModel].self, from: data)
                for candy in catalog {
                    if candy.image.hasPrefix("http") {
                        print(candy.image)
                        print("--- Find URL")
                        self.loadImage(candy.image) { image in
                            print("--- === Unwrap Success")
                            self.appendToCatalog(image: image, candy: candy)
                        }
                    } else if let image = UIImage(named: candy.image) {
                        print("--- Find image")
                        self.appendToCatalog(image: image, candy: candy)
                    }
                    
                }
                closure()
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    private func appendToCatalog(image: UIImage, candy: LoadingModel) {
        CatalogViewModel.shared.catalog.append(
            CatalogModel(
                image: image,
                imageDescription: candy.image,
                title: candy.title,
                weight: candy.weight,
                price: candy.price,
                amount: 0,
                description: candy.description,
                sales: candy.sales,
                id: candy.id
            )
        )
    }

    func postHandler(
        image: String,
        title: String,
        price: Int,
        weight: Int,
        sales: Bool,
        description: String,
        closure: @escaping () -> ()
    ) {
        let postData = LoadingModel(
            image: image,
            title: title,
            weight: weight,
            price: price,
            description: description,
            sales: sales,
            id: UUID())
        let encodedData = try? JSONEncoder().encode(postData)
        var request = URLRequest(url: URL(string: catalogVaporURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        closure()
    }
    func deleteHandler(
        id: UUID,
        closure: @escaping () -> ()
    ) {
        guard let link = URL(string: catalogVaporURL + "/" + id.uuidString) else { return }
        var request = URLRequest(url: link)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        closure()
    }
    
    func updateHandler(
        loadingModel: LoadingModel,
        closure: @escaping () -> ()
    ) {
        guard let link = URL(string: catalogVaporURL + "/" + loadingModel.id.uuidString)
        else { return }
        print(link)
        let encodedData = try? JSONEncoder().encode(loadingModel)
        var request = URLRequest(url: link)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        closure()
    }
}
