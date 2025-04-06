import UIKit

class FoodListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
    }
    
    private func setupNavigation() {
        title = "Food Menu"
        navigationController?.navigationBar.prefersLargeTitles = true
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
        
        tableView.register(FoodItemCell.self, forCellReuseIdentifier: "FoodItemCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
}

extension FoodListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemCell", for: indexPath) as? FoodItemCell else {
            return UITableViewCell()
        }
        
        let foodItem = dataManager.foodItems[indexPath.row]
        cell.configure(with: foodItem)
        cell.delegate = self
        
        return cell
    }
}

extension FoodListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FoodListViewController: FoodItemCellDelegate {
    func didTapAddButton(for foodItem: FoodItem) {
        let alertController = UIAlertController(title: "Select Group", message: "Choose a group to add this item to", preferredStyle: .actionSheet)
        
        for group in dataManager.getGroups() {
            let action = UIAlertAction(title: group, style: .default) { [weak self] _ in
                self?.dataManager.addToGroup(foodItem, groupName: group)
            }
            alertController.addAction(action)
        }
        
        let createAction = UIAlertAction(title: "Create New Group", style: .default) { [weak self] _ in
            self?.showCreateGroupDialog(for: foodItem)
        }
        alertController.addAction(createAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func showCreateGroupDialog(for foodItem: FoodItem) {
        let alertController = UIAlertController(title: "Create New Group", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Group Name"
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self, weak alertController] _ in
            guard let self = self,
                  let textField = alertController?.textFields?.first,
                  let groupName = textField.text, !groupName.isEmpty else { return }
            
            self.dataManager.createEmptyGroup(groupName: groupName)
            self.dataManager.addToGroup(foodItem, groupName: groupName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}