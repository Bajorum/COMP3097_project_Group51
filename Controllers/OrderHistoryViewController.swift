import UIKit
import Combine

class OrderHistoryViewController: UIViewController {
    
    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    private let dataManager = DataManager.shared
    private var orderIds: [Int] = []
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupUI()
        setupTableView()
        setupSubscription()
    }
    
    private func setupNavigation() {
        title = "Order History"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Empty state label
        emptyLabel.text = "You haven't placed any orders yet"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(OrderItemCell.self, forCellReuseIdentifier: "OrderItemCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func setupSubscription() {
        dataManager.ordersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        
        updateUI()
    }
    
    private func updateUI() {
        let orderHistory = dataManager.getOrderHistory()
        orderIds = Array(orderHistory.keys).sorted(by: >)  // Sort in descending order (newest first)
        
        if orderIds.isEmpty {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension OrderHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as? OrderItemCell else {
            return UITableViewCell()
        }
        
        let orderId = orderIds[indexPath.row]
        if let orderGroups = dataManager.getOrder(orderId) {
            cell.configure(with: orderId, orderGroups: orderGroups)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension OrderHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let orderId = orderIds[indexPath.row]
        if let orderGroups = dataManager.getOrder(orderId) {
            showOrderDetails(orderId: orderId, orderGroups: orderGroups)
        }
    }
    
    private func showOrderDetails(orderId: Int, orderGroups: [String: [FoodItem]]) {
        // Create an alert controller to show order details
        let alert = UIAlertController(title: "Order #\(orderId) Details", message: nil, preferredStyle: .alert)
        
        // Add message with order details
        var message = ""
        var totalCost: Double = 0
        
        // Sort groups alphabetically
        let sortedGroups = orderGroups.keys.sorted()
        
        for group in sortedGroups {
            let items = orderGroups[group] ?? []
            let subtotal = items.reduce(0.0) { $0 + $1.price }
            let groupTotal = subtotal * 1.13  // 13% tax
            totalCost += groupTotal
            
            message += "Group: \(group)\n"
            
            // Item counts - group by name to show quantities
            let itemCounts = Dictionary(grouping: items, by: { $0.name })
                .mapValues { $0.count }
                .sorted { $0.key < $1.key }
            
            for (itemName, count) in itemCounts {
                if let item = items.first(where: { $0.name == itemName }) {
                    message += "• \(count)x \(itemName) - $\(String(format: "%.2f", item.price * Double(count)))\n"
                }
            }
            
            message += "Subtotal: $\(String(format: "%.2f", subtotal))\n"
            message += "Total with Tax: $\(String(format: "%.2f", groupTotal))\n\n"
        }
        
        message += "Order Total: $\(String(format: "%.2f", totalCost))"
        
        alert.message = message
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        
        present(alert, animated: true)
    }
}