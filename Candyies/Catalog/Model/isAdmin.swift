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


class isAdminViewModel {
    static let shared = isAdminViewModel()
    var admin = true
}
