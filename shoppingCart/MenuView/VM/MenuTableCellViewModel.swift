//
//  MenuTableCellViewModel.swift
//  shoppingCart
//
//  Created by Mac on 2024/7/24.
//

import Foundation

class MenuTableCellViewModel {
    
    var name: String?
    var discribtion: String?
    var medium: Int?
    var large: Int?
    var imageView: URL?
    
    func setViewModel(response: DrinkRecord) {
        self.name = response.fields.name
        self.discribtion = response.fields.discribtion
        self.medium = response.fields.medium
        self.large = response.fields.large
        self.imageView = response.fields.image?.first?.url
    }
    
}
