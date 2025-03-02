import UIKit

protocol GroupItemCellDelegate: AnyObject {
    func didTapRemoveButton(for foodItem: FoodItem, in groupName: String)
}

class GroupItemCell: UITableViewCell {
    
    weak var delegate: GroupItemCellDelegate?
    private var foodItem: FoodItem?
    private var groupName: String?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: ThemeConstants.secondaryTextSize)
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
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: ThemeConstants.secondaryTextSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeConstants.lightGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .white
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(removeButton)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ThemeConstants.doubleMargin),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -ThemeConstants.standardMargin),
            
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -ThemeConstants.doubleMargin),
            
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ThemeConstants.doubleMargin),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(with foodItem: FoodItem, in groupName: String) {
        self.foodItem = foodItem
        self.groupName = groupName
        
        nameLabel.text = foodItem.name
        priceLabel.text = "$\(String(format: "%.2f", foodItem.price))"
    }
    
    @objc private func removeButtonTapped() {
        guard let foodItem = foodItem, let groupName = groupName else { return }
        delegate?.didTapRemoveButton(for: foodItem, in: groupName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        priceLabel.text = nil
        foodItem = nil
        groupName = nil
    }
}