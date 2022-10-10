//
//  CatalogModel.swift
//  Candyies
//
//  Created by Supodoco on 05.09.2022.
//

import Foundation
import UIKit

struct LoadingModel: Codable {
    let image: String
    let title: String
    let weight: Int
    let price: Int
    let description: String
    let sales: Bool
    let id: UUID
}

struct CatalogModel: Equatable {
    let image: UIImage
    let imageDescription: String
    let title: String
    let weight: Int
    let price: Int
    var amount: Int
    let description: String
    let sales: Bool
    let id: UUID
}


