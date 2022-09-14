//
//  User.swift
//  Candyies
//
//  Created by Supodoco on 14.09.2022.
//

import UIKit

struct Address {
    var city: String
    var street: String
    var house: String
    var apartment: String
    var floor: String
}

class User {
    static let shared = User()
    private init() {}
    var addresses: [Address]?
    var phoneNumber: String?
    
    func initialAddress(city: String, street: String, house: String, apartment: String,  floor: String) {
        addresses?.append(Address(city: city, street: street, house: house, apartment: apartment, floor: floor))
    }
    func setPhoneNumber(_ phone: String) {
        phoneNumber = phone
    }
    
    
    
}

class ee {
    var t = User.shared.initialAddress(city: "Евпатория", street: "проспект Победы", house: "55А", apartment: "8", floor: "2")
}
