//
//  OrderRequest.swift
//  shoppingCart
//
//  Created by Mac on 2024/8/23.
//

import Foundation

// MARK: - CreateOrderDrink
struct CreateOrderDrink: Codable {
    let records: [CreateOrderRecord]?
}

// MARK: - CreateOrderRecord
struct CreateOrderRecord: Codable {
    let fields: CreateOrderFields
}

// MARK: - CreateOrderFields
struct CreateOrderFields: Codable {
    let drinkName: String?
    let size: String?
    let ice: String?
    let sugar: String?
    let add: [String]?
    let price: String?
    let amount: String?
}

// MARK: - CreateOrderDrinkResponse
struct CreateOrderDrinkResponse: Codable {
    let records: [CreateOrderDrinkResponseRecord]?
}

// MARK: - CreateOrderDrinkResponseRecord
struct CreateOrderDrinkResponseRecord: Codable {
    let id: String
    let createdTime: String
    let fields: CreateOrderFields
}
