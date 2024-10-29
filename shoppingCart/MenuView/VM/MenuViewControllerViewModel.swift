//
//  MenuViewControllerViewModel.swift
//  shoppingCart
//
//  Created by Mac on 2024/7/23.
//

import Foundation
class MenuViewControllerViewModel {
    
    var menuTableCellViewModels: [MenuTableCellViewModel] = []
    var drinkDetailViewModels: [DrinkDetailViewModel] = []
    
    func setViewModel(response: [DrinkRecord]) {
        response.forEach { response in
            let menuTableCellViewModel = MenuTableCellViewModel()
            menuTableCellViewModel.setViewModel(response: response)
            menuTableCellViewModels.append(menuTableCellViewModel)
        }
        
        let drinkDetailViewModel = DrinkDetailViewModel()
        drinkDetailViewModel.setViewModel(response: response)
        drinkDetailViewModels.append(drinkDetailViewModel)
    }
}
