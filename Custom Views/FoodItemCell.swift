import UIKit

protocol FoodItemCellDelegate: AnyObject {
    func didTapAddButton(for foodItem: FoodItem, quantity: Int)
    func didToggleFavorite(for foodItem: FoodItem)
}

class FoodItemCell: UITableViewCell {
    
    weak var delegate: FoodItemCellDelegate?
    private var foodItem: FoodItem?
    private var quantity: Int = 1
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var quantityContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .systemGray5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        return button
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = "1"
        label.backgroundColor = .systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .systemGray5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(favoriteButton)
        
        // Setup quantity selector
        quantityContainer.addArrangedSubview(decreaseButton)
        quantityContainer.addArrangedSubview(quantityLabel)
        quantityContainer.addArrangedSubview(increaseButton)
        containerView.addSubview(quantityContainer)
        
        containerView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            
            favoriteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            favoriteButton.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            quantityContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            quantityContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            quantityContainer.heightAnchor.constraint(equalToConstant: 32),
            quantityContainer.widthAnchor.constraint(equalToConstant: 120),
            
            addButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            addButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            addButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with foodItem: FoodItem) {
        self.foodItem = foodItem
        self.quantity = 1
        
        nameLabel.text = foodItem.name
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        if let formattedPrice = formatter.string(from: NSNumber(value: foodItem.price)) {
            priceLabel.text = formattedPrice
        } else {
            priceLabel.text = "$\(String(format: "%.2f", foodItem.price))"
        }
        
        quantityLabel.text = "1"
        
        // Update favorite button appearance
        updateFavoriteButton(isFavorite: foodItem.isFavorite)
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemYellow : .systemGray
    }
    
    @objc private func favoriteButtonTapped() {
        guard let foodItem = foodItem else { return }
        delegate?.didToggleFavorite(for: foodItem)
        
        // Update UI (the model state will be updated via the delegate)
        let newFavoriteState = !foodItem.isFavorite
        updateFavoriteButton(isFavorite: newFavoriteState)
    }
    
    @objc private func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
            quantityLabel.text = "\(quantity)"
        }
    }
    
    @objc private func increaseQuantity() {
        quantity += 1
        quantityLabel.text = "\(quantity)"
    }
    
    @objc private func addButtonTapped() {
        guard let foodItem = foodItem else { return }
        delegate?.didTapAddButton(for: foodItem, quantity: quantity)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        priceLabel.text = nil
        quantityLabel.text = "1"
        quantity = 1
        foodItem = nil
    }
}