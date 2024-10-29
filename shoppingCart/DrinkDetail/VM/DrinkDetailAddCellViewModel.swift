//
//  DrinkDetailAddCellViewModel.swift
//  shoppingCart
//
//  Created by Mac on 2024/10/4.
//

import Foundation

class DrinkDetailAddCellViewModel {
    
    var drinkContentCellViewModels: [DrinkContentCellViewModel] = []
    var selectedIndexPath: IndexPath?
    
    func setViewModel(response: DrinkRecord) {
        response.fields.add?.forEach({ add in
            let vm = DrinkContentCellViewModel()
            vm.setAddViewModel(response: add)
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

extension DrinkDetailAddCellViewModel {
    func getSelectedItemLabels() -> [String] {
        return drinkContentCellViewModels.filter { $0.isSelectedState }.compactMap { $0.item }
    }
}
