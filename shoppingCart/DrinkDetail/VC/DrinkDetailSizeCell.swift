//
//  DrinkDetailSizeCell.swift
//  shoppingCart
//
//  Created by Mac on 2024/8/20.
//

import UIKit

class DrinkDetailSizeCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: DrinkDetailSizeCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "DrinkContentTableViewCell", bundle: nil), forCellReuseIdentifier: "DrinkContentTableViewCell")
    }
    
    func setCell(viewModel: DrinkDetailSizeCellViewModel) {
        self.viewModel = viewModel
    }
}

extension DrinkDetailSizeCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.drinkContentCellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkContentTableViewCell", for: indexPath) as! DrinkContentTableViewCell
        let cellViewModel = viewModel?.drinkContentCellViewModels[indexPath.row]
        cell.setCell(viewModel: cellViewModel!)
        
        cellViewModel?.didTapButton = { [weak self] in
            self?.viewModel?.selectItem(at: indexPath)
            if let updatePrice = self?.viewModel?.updatePrice {
                updatePrice()
            }
        }

        cell.selectionStyle = .none
        return cell
    }
}

extension DrinkDetailSizeCell: UITableViewDelegate {
    
}
