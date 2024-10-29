//
//  DrinkDetailSugarCellViewModel.swift
//  shoppingCart
//
//  Created by Mac on 2024/10/4.
//

import Foundation

class DrinkDetailSugarCellViewModel {
    
    var drinkContentCellViewModels: [DrinkContentCellViewModel] = []
    var selectedIndexPath: IndexPath?
    
    func setViewModel(response: DrinkRecord) {
        response.fields.sugar?.forEach({ sugar in
            let vm = DrinkContentCellViewModel()
            vm.setSugarViewModel(response: sugar)
            drinkContentCellViewModels.append(vm)
        })
    }
    
    func selectItem(at indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            return
        }
        
        if let previousIndexPath = selectedIndexPath {
            drinkContentCellViewModels[previousIndexPath.row].isSelectedState = false
            drinkContentCellViewModels[previousIndexPath.row].didUpdateSelectedState?()
        }
        
        selectedIndexPath = indexPath
        drinkContentCellViewModels[indexPath.row].isSelectedState = true
        drinkContentCellViewModels[indexPath.row].didUpdateSelectedState?()
    }
}

extension DrinkDetailSugarCellViewModel {
    func getSelectedItemLabel() -> String? {
        return drinkContentCellViewModels.first(where: { $0.isSelectedState })?.item
    }
}




