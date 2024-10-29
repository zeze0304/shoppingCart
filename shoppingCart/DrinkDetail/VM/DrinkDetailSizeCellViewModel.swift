//
//  DrinkDetailSizeCellViewModel.swift
//  shoppingCart
//
//  Created by Mac on 2024/10/3.
//

import Foundation

class DrinkDetailSizeCellViewModel {
    
    var drinkContentCellViewModels: [DrinkContentCellViewModel] = []
    var selectedIndexPath: IndexPath?
    var updatePrice: (() -> Void)?
    
    func setViewModel(response: DrinkRecord) {
        response.fields.size?.forEach({ size in
            let vm = DrinkContentCellViewModel()
            vm.setSizeViewModel(response: size)
            drinkContentCellViewModels.append(vm)
        })
    }
    
    func selectItem(at indexPath: IndexPath) {
        // 檢查是否是相同的項目。如果是，則不再更新
        if selectedIndexPath == indexPath {
            return // 如果已經選中了這個 indexPath，則不需要更新
        }
        
        // 取消之前的選中狀態
        if let previousIndexPath = selectedIndexPath {
            drinkContentCellViewModels[previousIndexPath.row].isSelectedState = false
            drinkContentCellViewModels[previousIndexPath.row].didUpdateSelectedState?()
        }
        
        // 更新選中的狀態
        selectedIndexPath = indexPath
        drinkContentCellViewModels[indexPath.row].isSelectedState = true
        drinkContentCellViewModels[indexPath.row].didUpdateSelectedState?()
    }
}

extension DrinkDetailSizeCellViewModel {
    func getSelectedItemLabel() -> String? {
        return drinkContentCellViewModels.first(where: { $0.isSelectedState })?.item
    }
}
