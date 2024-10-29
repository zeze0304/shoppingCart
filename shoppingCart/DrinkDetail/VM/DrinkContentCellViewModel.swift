//
//  DrinkContentCellViewModel.swift
//  shoppingCart
//
//  Created by Mac on 2024/10/3.
//

import Foundation

class DrinkContentCellViewModel {
    
    var item: String?
    
    var isSelectedState: Bool = false {
        didSet {
            didUpdateSelectedState?()
        }
    }
    var didTapButton: (() -> Void)?
    var didUpdateSelectedState: (() -> Void)?
    
    func setSizeViewModel(response: Size) {
        item = response.item
    }
    
    func setIceViewModel(response: Ice) {
        item = response.item
    }
    
    func setSugarViewModel(response: Sugar) {
        item = response.item
    }
    
    func setAddViewModel(response: Add) {
        item = response.item
    }
}
