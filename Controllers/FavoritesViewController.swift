import UIKit
import Combine

class FavoritesViewController: UIViewController {
    
    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupUI()
        setupTableView()
        setupSubscription()
    }
    
    private func setupNavigation() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Empty state label
        emptyLabel.text = "You haven't favorited any items yet"
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
        
        tableView.register(FoodItemCell.self, forCellReuseIdentifier: "FoodItemCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    private func setupSubscription() {
        dataManager.favoritesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        
        updateUI()
    }
    
    private func updateUI() {
        let favorites = dataManager.getFavoriteItems()
        
        if favorites.isEmpty {
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
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getFavoriteItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemCell", for: indexPath) as? FoodItemCell else {
            return UITableViewCell()
        }
        
        let favorites = dataManager.getFavoriteItems()
        if indexPath.row < favorites.count {
            let foodItem = favorites[indexPath.row]
            cell.configure(with: foodItem)
            cell.delegate = self
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - FoodItemCellDelegate
extension FavoritesViewController: FoodItemCellDelegate {
    func didTapAddButton(for foodItem: FoodItem, quantity: Int) {
        showGroupSelectionAlert(for: foodItem, quantity: quantity)
    }
    
    func didToggleFavorite(for foodItem: FoodItem) {
        dataManager.toggleFavorite(foodItemId: foodItem.id)
    }
    
    private func showGroupSelectionAlert(for foodItem: FoodItem, quantity: Int) {
        let alertController = UIAlertController(title: "Select Group", message: "Choose a group to add this item to", preferredStyle: .actionSheet)
        
        // Add actions for each existing group
        for group in dataManager.getGroups() {
            let action = UIAlertAction(title: group, style: .default) { [weak self] _ in
                self?.dataManager.addToGroup(foodItem, groupName: group, quantity: quantity)
            }
            alertController.addAction(action)
        }
        
        // Add "Create New Group" option
        let createAction = UIAlertAction(title: "Create New Group", style: .default) { [weak self] _ in
            self?.showCreateGroupDialog(for: foodItem, quantity: quantity)
        }
        alertController.addAction(createAction)
        
        // Add cancel option
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        // Present the action sheet
        present(alertController, animated: true)
    }
    
    private func showCreateGroupDialog(for foodItem: FoodItem, quantity: Int) {
        let alertController = UIAlertController(title: "Create New Group", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Group Name"
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self, weak alertController] _ in
            guard let self = self,
                  let textField = alertController?.textFields?.first,
                  let groupName = textField.text, !groupName.isEmpty else { return }
            
            self.dataManager.createEmptyGroup(groupName: groupName)
            self.dataManager.addToGroup(foodItem, groupName: groupName, quantity: