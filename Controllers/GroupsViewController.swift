import UIKit
import Combine

class GroupsViewController: UIViewController {
    
    private let tableView = UITableView()
    private let dataManager = DataManager.shared
    private var groups: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        setupDataSubscription()
    }
    
    private func setupNavigation() {
        title = "My Groups"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add button to create new group
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroupTapped))
        navigationItem.rightBarButtonItem = addButton
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
        
        tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    private func setupDataSubscription() {
        dataManager.foodGroupsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateGroups()
            }
            .store(in: &cancellables)
        
        updateGroups()
    }
    
    private func updateGroups() {
        groups = dataManager.getGroups()
        tableView.reloadData()
    }
    
    @objc private func addGroupTapped() {
        let alertController = UIAlertController(title: "Create New Group", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Group Name"
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self, weak alertController] _ in
            guard let self = self,
                  let textField = alertController?.textFields?.first,
                  let groupName = textField.text, !groupName.isEmpty, groupName != "Favorites" else { return }
            
            self.dataManager.createEmptyGroup(groupName: groupName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension GroupsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            return UITableViewCell()
        }
        
        let groupName = groups[indexPath.row]
        let items = dataManager.getItemsInGroup(groupName)
        let subtotal = dataManager.calculateSubtotal(groupName: groupName)
        let total = dataManager.calculateTotalWithTax(groupName: groupName)
        
        cell.configure(groupName: groupName, items: items, subtotal: subtotal, total: total)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - GroupCellDelegate
extension GroupsViewController: GroupCellDelegate {
    func didTapOptionsButton(for groupName: String) {
        guard groupName != "Favorites" else { return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Rename option
        let renameAction = UIAlertAction(title: "Rename Group", style: .default) { [weak self] _ in
            self?.showRenameGroupDialog(for: groupName)
        }
        alertController.addAction(renameAction)
        
        // Delete option
        let deleteAction = UIAlertAction(title: "Delete Group", style: .destructive) { [weak self] _ in
            self?.showDeleteGroupConfirmation(for: groupName)
        }
        alertController.addAction(deleteAction)
        
        // Cancel option
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func didTapRemoveButton(for foodItem: FoodItem, in groupName: String) {
        dataManager.removeFromGroup(foodItem, groupName: groupName)
    }
    
    private func showRenameGroupDialog(for groupName: String) {
        let alertController = UIAlertController(title: "Rename Group", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.text = groupName
        }
        
        let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self, weak alertController] _ in
            guard let self = self,
                  let textField = alertController?.textFields?.first,
                  let newName = textField.text, !newName.isEmpty, newName != "Favorites" else { return }
            
            self.dataManager.renameGroup(oldName: groupName, newName: newName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(renameAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func showDeleteGroupConfirmation(for groupName: String) {
        let alertController = UIAlertController(
            title: "Delete Group",
            message: "Are you sure you want to delete the group '\(groupName)'?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.dataManager.removeGroup(groupName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}