import UIKit

class OrderItemCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let orderIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let groupsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let disclosureIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .default
        backgroundColor = .clear
        contentView.addSubview(containerView)
        
        containerView.addSubview(orderIdLabel)
        containerView.addSubview(itemCountLabel)
        containerView.addSubview(totalLabel)
        containerView.addSubview(groupsLabel)
        containerView.addSubview(disclosureIndicator)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            orderIdLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            orderIdLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            itemCountLabel.topAnchor.constraint(equalTo: orderIdLabel.bottomAnchor, constant: 4),
            itemCountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            totalLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            totalLabel.trailingAnchor.constraint(equalTo: disclosureIndicator.leadingAnchor, constant: -8),
            
            groupsLabel.topAnchor.constraint(equalTo: itemCountLabel.bottomAnchor, constant: 8),
            groupsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            groupsLabel.trailingAnchor.constraint(equalTo: disclosureIndicator.leadingAnchor, constant: -8),
            groupsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            disclosureIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            disclosureIndicator.widthAnchor.constraint(equalToConstant: 12),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with orderId: Int, orderGroups: [String: [FoodItem]]) {
        // Calculate total items
        let totalItems = orderGroups.values.reduce(0) { $0 + $1.count }
        
        // Calculate total cost
        let totalCost = orderGroups.values.reduce(0.0) { total, items in
            let subtotal = items.reduce(0.0) { $0 + $1.price }
            return total + (subtotal * 1.13) // 13% tax
        }
        
        // Format currency
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        let formattedTotal = formatter.string(from: NSNumber(value: totalCost)) ?? "$\(String(format: "%.2f", totalCost))"
        
        // Set labels
        orderIdLabel.text = "Order #\(orderId)"
        itemCountLabel.text = "\(totalItems) item\(totalItems == 1 ? "" : "s")"
        totalLabel.text = formattedTotal
        
        // Format groups
        let groupsText = orderGroups.keys.sorted().joined(separator: ", ")
        groupsLabel.text = "Groups: \(groupsText)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        orderIdLabel.text = nil
        itemCountLabel.text = nil
        totalLabel.text = nil
        groupsLabel.text = nil
    }
}