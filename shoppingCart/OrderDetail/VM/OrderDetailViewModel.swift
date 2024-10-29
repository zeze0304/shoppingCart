//
//  OrderDetailViewModel.swift
//  shoppingCart
//
//  Created by Mac on 2024/10/6.
//

import Foundation

class OrderDetailViewModel {
    
    var orderTableCellViewModels: [OrderTableCellViewModel] = []
    
    var orderID: String?
        
    func setViewModel(response: [CreateOrderRecord]) {
        response.forEach { record in
            let vm = OrderTableCellViewModel()
            vm.setViewModel(response: record)
            orderTableCellViewModels.append(vm)
        }
    }
    
    func setViewModel(idResponse: [CreateOrderDrinkResponseRecord]) {
        
        idResponse.forEach { idResponse in
            let vm = OrderTableCellViewModel()
            vm.setViewModel(idResponse: idResponse)
            orderTableCellViewModels.append(vm)
        }
    }
}
