//
//  OrderTableCellViewModel.swift
//  shoppingCart
//
//  Created by Mac on 2024/10/6.
//

import Foundation

class OrderTableCellViewModel {
    
    var drinkName: String?
    var size: String?
    var ice: String?
    var sugar: String?
    var add: [String]?
    var amount: String?
    var price: String?
    
    var id: String?
    
    func setViewModel(response: CreateOrderRecord) {
        self.drinkName = response.fields.drinkName
        self.size = response.fields.size
        self.ice = response.fields.ice
        self.sugar = response.fields.sugar
        self.add = response.fields.add
        self.amount = response.fields.amount
        self.price = response.fields.price
    }
    
    func setViewModel(idResponse: CreateOrderDrinkResponseRecord) {
        self.id = idResponse.id
    }
}
