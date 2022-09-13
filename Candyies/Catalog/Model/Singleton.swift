//
//  CartConfigure.swift
//  Candyies
//
//  Created by Supodoco on 11.09.2022.
//

import UIKit

class Singleton {
    static let shared = Singleton()
    var data: [Int: CatalogModel] = [:]
    let counter = 50
    let delivery: (cost: Int, free: Int) = (200,0)
    let freeDeliveryMinSum = 2300
    var loaded = (false, false)
    
    var sectionOne: [Int: CatalogModel] {
        data.filter { $0.key < counter }
    }
    var sectionTwo: [Int: CatalogModel] {
        data.filter { $0.key >= counter }
    }
    var cart: [Int: CatalogModel] {
        data.filter { $0.value.amount > 0 }
    }
    var cartTotalPrice: Int {
        cart.map { $0.value.price * $0.value.amount }.reduce(0, +)
    }
    var cartArray: [CatalogModel] {
        cart.sorted { $0.key > $1.key } .map { $0.value }
    }
    
    private init() { }
    
    func clearCart() {
        for index in cart.keys {
            data[index]?.amount = 0
        }
    }
}
