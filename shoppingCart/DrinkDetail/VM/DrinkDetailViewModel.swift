//
//  DrinkDetailViewModel.swift
//  shoppingCart
//
//  Created by Mac on 2024/8/13.
//

import Foundation
class DrinkDetailViewModel {
    
    var drinkDetailSizeCellViewModels: [DrinkDetailSizeCellViewModel] = []
    var drinkDetailIceCellViewModels: [DrinkDetailIceCellViewModel] = []
    var drinkDetailSugarCellViewModels: [DrinkDetailSugarCellViewModel] = []
    var drinkDetailAddCellViewModels: [DrinkDetailAddCellViewModel] = []
    
    var response: [DrinkRecord]?
    
    var drinkName: String?
    var medium: String?
    var large: String?
    var amount: String?
    
    var updatePrice: (() -> Void)?
    
    func setViewModel(response: [DrinkRecord]) {
        response.forEach({ response in
            let sizevm = DrinkDetailSizeCellViewModel()
            sizevm.setViewModel(response: response)
            drinkDetailSizeCellViewModels.append(sizevm)
            
            let icevm = DrinkDetailIceCellViewModel()
            icevm.setViewModel(response: response)
            drinkDetailIceCellViewModels.append(icevm)
            
            let sugarvm = DrinkDetailSugarCellViewModel()
            sugarvm.setViewModel(response: response)
            drinkDetailSugarCellViewModels.append(sugarvm)
            
            let addvm = DrinkDetailAddCellViewModel()
            addvm.setViewModel(response: response)
            drinkDetailAddCellViewModels.append(addvm)
        })
        
        self.response = response
    }
    
    enum Section: Int, CaseIterable {
        case size
        case ice
        case sugar
        case add
    }
    
    func setNumberOfSections() -> Int {
        return Section.allCases.count
    }
    
    func setNumberOfRowsInSection(section: Int) -> Int {
        switch Section(rawValue: section) {
        case .size:
            return drinkDetailSizeCellViewModels.count
        case .ice:
            return drinkDetailIceCellViewModels.count
        case .sugar:
            return drinkDetailSugarCellViewModels.count
        case .add:
            return drinkDetailAddCellViewModels.count
        default:
            return 0
        }
    }
}

extension DrinkDetailViewModel {
    func getSelectedSize() -> String? {
        return drinkDetailSizeCellViewModels.first?.getSelectedItemLabel()
    }
    
    func getSelectedIce() -> String? {
        return drinkDetailIceCellViewModels.first?.getSelectedItemLabel()
    }
    
    func getSelectedSugar() -> String? {
        return drinkDetailSugarCellViewModels.first?.getSelectedItemLabel()
    }
    
    func getSelectedAdd() -> [String] {
        return drinkDetailAddCellViewModels.first?.getSelectedItemLabels() ?? []
    }
    
    func getDrinkName() -> String? {
        return drinkName
    }
    
    func getAmount() -> String? {
        return amount
    }
    
    func getPrice() -> String? {
        if getSelectedSize() == "Ｍ" {
            if let mediumPriceString = medium, let mediumPrice = Int(mediumPriceString),
               let amountString = amount, let amountInt = Int(amountString) {
                let price = mediumPrice * amountInt
                return String(price)
            }
        } else if getSelectedSize() == "Ｌ" {
            if let largePriceString = large, let largePrice = Int(largePriceString),
               let amountString = amount, let amountInt = Int(amountString) {
                let price = largePrice * amountInt
                return String(price)
            }
        }
        
        return nil
    }
}
