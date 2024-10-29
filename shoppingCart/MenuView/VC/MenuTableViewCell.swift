//
//  MenuTableViewCell.swift
//  shoppingCart
//
//  Created by Mac on 2024/7/23.
//

import UIKit
import Kingfisher

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
    @IBOutlet weak var largeLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    
    var viewModel: MenuTableCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setCell(viewModel: MenuTableCellViewModel) {
        self.viewModel = viewModel
        self.nameLabel.text = "Item: \(viewModel.name ?? "")"
        self.discriptionLabel.text = "Flavor：\(viewModel.discribtion ?? "")"
        self.mediumLabel.text = "M: $\(viewModel.medium ?? 0)"
        self.largeLabel.text = "L: $\(viewModel.large ?? 0)"
        self.drinkImageView.kf.setImage(with: viewModel.imageView) 
    }
    
}
