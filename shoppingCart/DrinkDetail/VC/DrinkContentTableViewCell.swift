//
//  DrinkContentTableViewCell.swift
//  shoppingCart
//
//  Created by Mac on 2024/8/20.
//

import UIKit

class DrinkContentTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    
    var viewModel: DrinkContentCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    func setCell(viewModel: DrinkContentCellViewModel) {
        self.viewModel = viewModel
        itemLabel.text = viewModel.item
        updateButtonImage()

        viewModel.didUpdateSelectedState = { [weak self] in
            self?.updateButtonImage()
        }
    }
    
    @IBAction func onTouchButton(_ sender: Any) {
        viewModel?.didTapButton!()
    }
    
    private func updateButtonImage() {
        let imageName = viewModel?.isSelectedState ?? false ? "circle.inset.filled" : "circle"
        radioButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
