//
//  DrinkDetailViewController.swift
//  shoppingCart
//
//  Created by Mac on 2024/8/13.
//

import UIKit

class DrinkDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    private let baseURL = "https://api.airtable.com/v0/appo6UN6o02La6eW3/tblysb1UUeGP4vP6f"
    private let apiKey = "patLzei0zOQYscO9u.21819f0da995b4b4b3c3cc0bbdf1bbef7c078cb17809921da330752f1e3392e6"
    private var drinksOfselectedCategory = [DrinkRecord]()
    
    var drinks = [DrinkRecord]()
    var viewModel = DrinkDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDrinkData()
        setUp()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 // 設置一個估計高度
        
        tableView.register(UINib(nibName: "DrinkDetailSizeCell", bundle: nil), forCellReuseIdentifier: "DrinkDetailSizeCell")
        
        tableView.register(UINib(nibName: "DrinkDetailIceCell", bundle: nil), forCellReuseIdentifier: "DrinkDetailIceCell")
        
        tableView.register(UINib(nibName: "DrinkDetailSugarCell", bundle: nil), forCellReuseIdentifier: "DrinkDetailSugarCell")
        
        tableView.register(UINib(nibName: "DrinkDetailAddCell", bundle: nil), forCellReuseIdentifier: "DrinkDetailAddCell")
        
        tableView.reloadData()
    }
    
    // MARK: - GET Drink
    func fetchDrinkData() {
        guard let url = URL(string: baseURL) else { return }
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self, let data = data else { return }
            do {
                // 印出 data 確認是否正確
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("DrinkDetailViewController Received JSON string: \(jsonString)")
                }
                
                // 抓取資料時(GET)，建立Decoder進行解碼
                let decoder = JSONDecoder()
                let drink = try decoder.decode(DrinkResponse.self, from: data)
                
                // 將抓到的資料存入變數drinks
                self.drinks = drink.records ?? []
                
                // 將飲品類別第一頁「季節限定」的飲品存入變數drinksOfselectedCategory
                for drink in self.drinks {
                    if drink.fields.category == .seasonal {
                        self.drinksOfselectedCategory.append(drink)
                    }
                }
                
                // 在主執行緒更新畫面
                DispatchQueue.main.async {
                    self.setVC(viewModel: self.viewModel)
                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                // 印出更詳細的錯誤訊息
                print("Failed to decode JSON: \(error), \(error.userInfo)")
            }
        }.resume()
    }
    
    func setVC(viewModel: DrinkDetailViewModel) {
        viewModel.setViewModel(response: drinks)
        viewModel.amount = self.amountLabel.text
        updatePrice()
    }
    
    func setInfo(drinkName: String?, medium: String?, large: String?) {
        viewModel.drinkName = drinkName
        viewModel.medium = medium
        viewModel.large = large
    }
    
    @IBAction func addToCart(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func onTouchplus(_ sender: Any) {
        if let currentAmount = Int(amountLabel.text ?? "0") {
            let newAmount = currentAmount + 1
            amountLabel.text = "\(newAmount)"
            viewModel.amount = amountLabel.text
            updatePrice()
        }
    }
    
    @IBAction func onTouchMinus(_ sender: Any) {
        if let currentAmount = Int(amountLabel.text ?? "0"), currentAmount > 0 {
            let newAmount = currentAmount - 1
            amountLabel.text = "\(newAmount)"
            viewModel.amount = amountLabel.text
            updatePrice()
        }
    }
}

extension DrinkDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.setNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.setNumberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch DrinkDetailViewModel.Section(rawValue: indexPath.section) {
        case .size:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkDetailSizeCell", for: indexPath) as! DrinkDetailSizeCell
            cell.setCell(viewModel: viewModel.drinkDetailSizeCellViewModels[indexPath.row])
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            
            viewModel.drinkDetailSizeCellViewModels[indexPath.row].updatePrice = { [weak self] in
                self?.updatePrice()
            }
            
            return cell
            
        case .ice:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkDetailIceCell", for: indexPath) as! DrinkDetailIceCell
            cell.setCell(viewModel: viewModel.drinkDetailIceCellViewModels[indexPath.row])
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
            
        case .sugar:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkDetailSugarCell", for: indexPath) as! DrinkDetailSugarCell
            cell.setCell(viewModel: viewModel.drinkDetailSugarCellViewModels[indexPath.row])
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
            
        case .add:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkDetailAddCell", for: indexPath) as! DrinkDetailAddCell
            cell.setCell(viewModel: viewModel.drinkDetailAddCellViewModels[indexPath.row])
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
            
        default:
            fatalError("Unexpected IndexPath")
        }
    }
}

extension DrinkDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch DrinkDetailViewModel.Section(rawValue: indexPath.section) {
        case .size:
            return 160 + 10
        case .ice:
            return 365 + 10
        case .sugar:
            return 260 + 10
        case .add:
            return 160
        default:
            return UITableView.automaticDimension
        }
    }
}

extension DrinkDetailViewController {
    
    private func createOrderData() -> CreateOrderRecord? {
        guard let size = viewModel.getSelectedSize(),
              let ice = viewModel.getSelectedIce(),
              let sugar = viewModel.getSelectedSugar() else {
            print("Missing required selections")
            return nil
        }
        
        let add = viewModel.getSelectedAdd()
        
        guard let drinkName = viewModel.getDrinkName(),
              let price = viewModel.getPrice() else {
            print("Missing drink name or price")
            return nil
        }
        
        let amount = viewModel.getAmount() ?? ""
        
        let fields = CreateOrderFields(
            drinkName: drinkName,
            size: size,
            ice: ice,
            sugar: sugar,
            add: add,
            price: price,
            amount: amount
        )
        
        return CreateOrderRecord(fields: fields)
    }
    
    private func updatePrice() {
        if let price = viewModel.getPrice() {
            priceLabel.text = "$\(price)"
        }
    }
    
    private func setUp() {
        amountLabel.text = "1"
        priceLabel.text = "$-"
    }
    
    private func showAlert() {
    let alert = UIAlertController(title: "Are you sure you want to Add?", message: "Press No if you haven't finished", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
        guard let orderData = self.createOrderData() else {
            print("Failed to create order data")
            return
        }
        
        let singleOrderData = CreateOrderDrink(records: [orderData])
        
        // POST
        MenuViewController.shared.postOrder(orderData: singleOrderData) { result in
            switch result {
            case .success(let createOrderResponse):

                NotificationCenter.default.post(name: NSNotification.Name("OrderUpdated"), object: nil)
                
                print(createOrderResponse)
            case .failure(let error):
                print(error)
            }
        }
        self.dismiss(animated: true)
    }))
    present(alert, animated: true, completion: nil)
    }
}
