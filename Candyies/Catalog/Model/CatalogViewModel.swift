//
//  CartConfigure.swift
//  Candyies
//
//  Created by Supodoco on 11.09.2022.
//

import UIKit

class CatalogViewModel {
    static let shared = CatalogViewModel()
    var catalog: [CatalogModel] = []
    let delivery: (cost: Int, free: Int) = (200,0)
    let freeDeliveryMinSum = 2300
    var loaded = (false, false)
    
    var sectionOne: [CatalogModel] {
        catalog.filter { $0.sales }
    }
    var sectionTwo: [CatalogModel] {
        catalog.filter { !$0.sales }
    }
    var cart: [CatalogModel] {
        catalog.filter { $0.amount > 0 }
    }
    var cartTotalPrice: Int {
        catalog.map { $0.price * $0.amount }.reduce(0, +)
    }
    
    private init() { }
    
    func clearCart() {
        for (ind, _) in catalog.enumerated() {
            catalog[ind].amount = 0
        }
    }
    
    func changeAmount(id: UUID, calculate: Counter) {
        for (ind, item) in CatalogViewModel.shared.catalog.enumerated() {
            if item.id == id {
                switch calculate {
                case .plus:
                    CatalogViewModel.shared.catalog[ind].amount += 1
                    break
                case .minus:
                    CatalogViewModel.shared.catalog[ind].amount -= 1
                    break
                }
            }
        }
    }
}
