//
//  MenuViewController.swift
//  shoppingCart
//
//  Created by Mac on 2024/7/23.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let baseURL = "https://api.airtable.com/v0/appo6UN6o02La6eW3/tblbD6n3A2Hhv7BQd"
    private let apiKey = "patrzI9SbTeHnotSf.01c827699525638e5a63118410a5bc6c82072215db85b3b4096578a0aebf7884"
    private let postURL = "https://api.airtable.com/v0/appo6UN6o02La6eW3/OrderDetail"
    
    private var drinksOfselectedCategory = [DrinkRecord]()
    var drinks = [DrinkRecord]()
    let viewModel = MenuViewControllerViewModel()
    
    static let shared = MenuViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDrinkData()
        
        tableView.dataSource = self
        tableView.delegate = self
        let cell = UINib.init(nibName: "MenuTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "MenuTableViewCell")
    }
    
    func postOrder(orderData: CreateOrderDrink, completion: @escaping (Result<String,Error>) -> Void) {
        guard let url = URL(string: postURL) else { return }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        guard let orderURL = components.url else { return }

        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(orderData)

            URLSession.shared.dataTask(with: request) { data, response, resError in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let orderResponse = try decoder.decode(CreateOrderDrinkResponse.self, from: data)

                        // 確保我們取得的 response 是正確的，並且有 id 可供使用
                        if let firstRecord = orderResponse.records?.first {
                            let orderId = firstRecord.id
                                                        
                            completion(.success(orderId))
                            
                            
                            print("Order ID: \(orderId)")
                        } else {
                            completion(.failure(NSError(domain: "No ID found in response", code: 0, userInfo: nil)))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else if let resError = resError {
                    completion(.failure(resError))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
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
                    print("MenuViewController Received JSON string: \(jsonString)")
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
    
    
    // MARK: - DELETE Order
    func deleteOrder(orderID: String, completion: @escaping(Result<String,Error>) -> Void) {
        
        guard var orderURL = URL(string: baseURL) else { return }
        
        // 帶入要刪除的訂單id
        orderURL = orderURL.appendingPathComponent(orderID)
        
        guard let components = URLComponents(url: orderURL, resolvingAgainstBaseURL: true) else { return }
        guard let orderURL = components.url else { return }
        
        var request = URLRequest(url: orderURL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, resError in
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               resError == nil,
               let data = data,
               let content = String(data: data, encoding: .utf8) {
                completion(.success(content))
            } else if let resError = resError {
                completion(.failure(resError))
            }
        }.resume()
    }
    
    func setVC(viewModel: MenuViewControllerViewModel) {
        viewModel.setViewModel(response: drinks)
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuTableCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.setCell(viewModel: (viewModel.menuTableCellViewModels[indexPath.row]))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = getVC(st: "Main", vc: "DrinkDetailViewController") as! DrinkDetailViewController

        vc.setInfo(drinkName: viewModel.menuTableCellViewModels[indexPath.row].name, medium: String(viewModel.menuTableCellViewModels[indexPath.row].medium ?? 0), large: String(viewModel.menuTableCellViewModels[indexPath.row].large ?? 0))
        
        self.present(vc, animated: true)
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension MenuViewController {
    func getVC(st: String, vc: String) -> UIViewController {

    let storyboard = UIStoryboard(name: st, bundle: Bundle.main)
    let viewController = storyboard.instantiateViewController(withIdentifier: vc)
    return viewController
    }
}
