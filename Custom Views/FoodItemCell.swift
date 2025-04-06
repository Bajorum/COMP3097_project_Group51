import UIKit

protocol FoodItemCellDelegate: AnyObject {
    func didTapAddButton(for foodItem: FoodItem)
}

class FoodItemCell: UITableViewCell {
    
    weak var delegate: FoodItemCellDelegate?
    private var foodItem: FoodItem?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: ThemeConstants.primaryTextSize)
        label.textColor = ThemeConstants.textPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: ThemeConstants.secondaryTextSize)
        label.textColor = ThemeConstants.textSecondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.backgroundColor = ThemeConstants.primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 4
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
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

    //Updated the setup Views 
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = ThemeConstants.backgroundColor
        
        contentView.addSubview(containerView)
        ThemeConstants.styleAsAndroidCard(view: containerView)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ThemeConstants.standardMargin),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ThemeConstants.standardMargin),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ThemeConstants.standardMargin),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ThemeConstants.standardMargin),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ThemeConstants.doubleMargin),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ThemeConstants.doubleMargin),
            nameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -ThemeConstants.standardMargin),
            
            priceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ThemeConstants.doubleMargin),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ThemeConstants.doubleMargin),
            
            addButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: ThemeConstants.standardMargin),
            addButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ThemeConstants.doubleMargin),
            addButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -ThemeConstants.doubleMargin)
        ])
    }
    
    func configure(with foodItem: FoodItem) {
        self.foodItem = foodItem
        
        nameLabel.text = foodItem.name
        priceLabel.text = "$\(String(format: "%.2f", foodItem.price))"
    }
    
    @objc private func addButtonTapped() {
        guard let foodItem = foodItem else { return }
        delegate?.didTapAddButton(for: foodItem)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        priceLabel.text = nil
        foodItem = nil
    }
}
