//
//  DrinkDetailIceCellViewModel.swift
//  shoppingCart
//
//  Created by Mac on 2024/10/4.
//

import Foundation

class DrinkDetailIceCellViewModel {
    
    var drinkContentCellViewModels: [DrinkContentCellViewModel] = []
    var selectedIndexPath: IndexPath?
    
    func setViewModel(response: DrinkRecord) {
        response.fields.ice?.forEach({ ice in
            let vm = DrinkContentCellViewModel()
            vm.setIceViewModel(response: ice)
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

extension DrinkDetailIceCellViewModel {
    func getSelectedItemLabel() -> String? {
        return drinkContentCellViewModels.first(where: { $0.isSelectedState })?.item
    }
}
