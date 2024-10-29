//
//  Model.swift
//  shoppingCart
//
//  Created by Mac on 2024/7/24.
//

import Foundation

// MARK: - DrinkResponse
struct DrinkResponse: Decodable {
    let records: [DrinkRecord]?
}

// MARK: - DrinkRecord
struct DrinkRecord: Decodable {
    let fields: DrinkFields
}

struct DrinkFields: Decodable {
    let name: String?
    let discribtion: String?
    let medium: Int?
    let large: Int?
    let image: [DrinkImage]?
    let category: Category?
    let sugar: [Sugar]?
    let size: [Size]?
    let ice: [Ice]?
    let add: [Add]?
}

struct Sugar: Decodable {
    let item: String

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.item = try container.decode(String.self)
    }
}

struct Size: Decodable {
    let item: String

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.item = try container.decode(String.self)
    }
}

struct Ice: Decodable {
    let item: String

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.item = try container.decode(String.self)
    }
}

struct Add: Decodable {
    let item: String

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.item = try container.decode(String.self)
    }
}


// MARK: - Category
enum Category: String, Decodable {
    case classic = "單品茶"
    case milk = "歐蕾"
    case seasonal = "季節限定"
}

// MARK: - DrinkImage
struct DrinkImage: Decodable {
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
