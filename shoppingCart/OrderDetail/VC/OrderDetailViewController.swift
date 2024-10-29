//
//  OrderDetailViewController.swift
//  shoppingCart
//
//  Created by Mac on 2024/10/6.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let apiKey = "patrzI9SbTeHnotSf.01c827699525638e5a63118410a5bc6c82072215db85b3b4096578a0aebf7884"
    private let url = "https://api.airtable.com/v0/appo6UN6o02La6eW3/OrderDetail"
    
    private var drinksOfselectedCategory = [CreateOrderRecord]()
    var drinks = [CreateOrderRecord]()
    var idResponse = [CreateOrderDrinkResponseRecord]()
    
    var viewModel = OrderDetailViewModel()
    static let shared = OrderDetailViewController()
    
    var orderID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getOrder()
        getId()
        
        tableView.dataSource = self
        tableView.delegate = self
        let cell = UINib.init(nibName: "OrderTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "OrderTableViewCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 240
        
        // 註冊通知
        NotificationCenter.default.addObserver(self, selector: #selector(orderUpdated), name: NSNotification.Name("OrderUpdated"), object: nil)
    }
    
    // 接收更新通知
    @objc func orderUpdated() {
        getOrder() // 更新數據
        getId()
    }
    
    // 別忘了在 deinit 中移除觀察者
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getOrder() {
        guard let url = URL(string: url) else { return }
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self, let data = data else { return }
            do {
                // 印出 data 確認是否正確
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("OrderDetailViewController Received JSON string: \(jsonString)")
                }

                // 清空現有的飲品數據以避免重複
                self.drinks.removeAll()

                // 抓取資料時(GET)，建立Decoder進行解碼
                let decoder = JSONDecoder()
                let drink = try decoder.decode(CreateOrderDrink.self, from: data)

                // 將抓到的資料存入變數drinks
                self.drinks = drink.records ?? []

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
    
    func getId() {
        guard let url = URL(string: url) else { return }
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self, let data = data else { return }
            do {
                // 印出 data 確認是否正確
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("getId Received JSON string: \(jsonString)")
                }
                
                // 清空現有的飲品數據以避免重複
                self.idResponse.removeAll()
                
                // 抓取資料時(GET)，建立Decoder進行解碼
                let decoder = JSONDecoder()
                let drink = try decoder.decode(CreateOrderDrinkResponse.self, from: data)
                
                // 將抓到的資料存入變數drinks
                self.idResponse = drink.records ?? []
                
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
    
    func setVC(viewModel: OrderDetailViewModel) {
        // 先清空舊的 ViewModel
        viewModel.orderTableCellViewModels.removeAll()
        
        // 建立一個新的 ViewModel 陣列
        for drink in drinks {
            let vm = OrderTableCellViewModel()
            vm.setViewModel(response: drink)

            // 根據 drink.fields 進行匹配
            if let matchingIdResponse = idResponse.first(where: {
                $0.fields.drinkName == drink.fields.drinkName &&
                $0.fields.size == drink.fields.size
            }) {
                vm.id = matchingIdResponse.id
            }

            viewModel.orderTableCellViewModels.append(vm)
        }

        // 更新 UI
        self.tableView.reloadData()
    }
}

extension OrderDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orderTableCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        cell.setCell(viewModel: (viewModel.orderTableCellViewModels[indexPath.row]))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let order = self.viewModel.orderTableCellViewModels[indexPath.row].id
            
            // DELETE
            MenuViewController.shared.deleteOrder(orderID: order ?? "") { result in
                switch result {
                case .success(let message):
                    print(message)
                    
                    DispatchQueue.main.async {
                        self.viewModel.orderTableCellViewModels.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                    }
                case .failure(let error):
                    print("Error deleting order: \(error)")
                }
            }
        }
    }
}

extension OrderDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension OrderDetailViewController {
    func getVC(st: String, vc: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: st, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: vc)
        return viewController
    }
}

extension OrderDetailViewController {
    func addOrderRecord(newOrder: CreateOrderRecord) {
        self.drinks.append(newOrder)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
