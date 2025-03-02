import UIKit

protocol GroupCellDelegate: AnyObject {
    func didTapOptionsButton(for groupName: String)
    func didTapRemoveButton(for foodItem: FoodItem, in groupName: String)
}

class GroupCell: UITableViewCell {
    
    weak var delegate: GroupCellDelegate?
    private var groupName: String?
    private var items: [FoodItem] = []
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeConstants.lightGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: ThemeConstants.headerTextSize)
        label.textColor = ThemeConstants.textPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "ellipsis")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = ThemeConstants.textPrimaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(optionsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeConstants.lightGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subtotalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: ThemeConstants.secondaryTextSize)
        label.textColor = ThemeConstants.textSecondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: ThemeConstants.secondaryTextSize)
        label.textColor = ThemeConstants.textPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = ThemeConstants.backgroundColor
        
        contentView.addSubview(containerView)
        ThemeConstants.styleAsAndroidCard(view: containerView)
        
        // Add header
        containerView.addSubview(headerView)
        headerView.addSubview(groupNameLabel)
        headerView.addSubview(optionsButton)
        
        // Add table
        containerView.addSubview(tableView)
        
        // Add divider
        containerView.addSubview(dividerView)
        
        // Add footer
        containerView.addSubview(footerView)
        footerView.addSubview(subtotalLabel)
        footerView.addSubview(totalLabel)
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ThemeConstants.standardMargin),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ThemeConstants.standardMargin),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ThemeConstants.standardMargin),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ThemeConstants.standardMargin),
            
            // Header
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            groupNameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: ThemeConstants.doubleMargin),
            groupNameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            groupNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: optionsButton.leadingAnchor, constant: -ThemeConstants.standardMargin),
            
            optionsButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -ThemeConstants.doubleMargin),
            optionsButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            optionsButton.widthAnchor.constraint(equalToConstant: 24),
            optionsButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Table
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            // Divider
            dividerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            // Footer
            footerView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
            subtotalLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: ThemeConstants.standardMargin),
            subtotalLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: ThemeConstants.doubleMargin),
            
            totalLabel.topAnchor.constraint(equalTo: subtotalLabel.bottomAnchor, constant: 4),
            totalLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: ThemeConstants.doubleMargin),
            totalLabel.bottomAnchor.constraint(lessThanOrEqualTo: footerView.bottomAnchor, constant: -ThemeConstants.standardMargin)
        ])
    }
    
    private func setupTableView() {
        tableView.register(GroupItemCell.self, forCellReuseIdentifier: "GroupItemCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 44
    }
    
    func configure(groupName: String, items: [FoodItem], subtotal: Double, total: Double) {
        self.groupName = groupName
        self.items = items
        
        groupNameLabel.text = groupName
        
        subtotalLabel.text = "Subtotal: $\(String(format: "%.2f", subtotal))"
        totalLabel.text = "Total (inc. 13% tax): $\(String(format: "%.2f", total))"
        
        // Show/hide options button based on group name
        optionsButton.isHidden = (groupName == "Favorites")
        
        // Update table height constraint based on content
        let tableHeight = CGFloat(items.count) * tableView.rowHeight
        
        // Remove previous height constraint if exists
        for constraint in tableView.constraints {
            if constraint.firstAttribute == .height {
                tableView.removeConstraint(constraint)
            }
        }
        
        // Add new height constraint
        tableView.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
        
        tableView.reloadData()
    }
    
    @objc private func optionsButtonTapped() {
        guard let groupName = groupName else { return }
        delegate?.didTapOptionsButton(for: groupName)
    }
}

// MARK: - UITableViewDataSource
extension GroupCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupItemCell", for: indexPath) as? GroupItemCell,
              let groupName = groupName else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configure(with: item, in: groupName)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GroupCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - GroupItemCellDelegate
extension GroupCell: GroupItemCellDelegate {
    func didTapRemoveButton(for foodItem: FoodItem, in groupName: String) {
        delegate?.didTapRemoveButton(for: foodItem, in: groupName)
    }
}