//
//  OrderTableViewCell.swift
//  shoppingCart
//
//  Created by Mac on 2024/10/6.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var viewModel: OrderTableCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setCell(viewModel: OrderTableCellViewModel) {
        self.viewModel = viewModel
        self.drinkNameLabel.text = "Item: \(viewModel.drinkName ?? "")"
        self.sizeLabel.text = "Size: \(viewModel.size ?? "")"
        self.iceLabel.text = "Ice：\(viewModel.ice ?? "")"
        self.sugarLabel.text = "Sweet: \(viewModel.sugar ?? "")"
        self.addLabel.text = "Add: \(viewModel.add?.joined(separator: ", ") ?? "")"
        self.amountLabel.text = "Quantity: \(viewModel.amount ?? "")"
        self.priceLabel.text = "Price: $\(viewModel.price ?? "")"
    }
    
}
