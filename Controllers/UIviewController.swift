import UIKit

class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "SplashIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Food Selection"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToMainApp()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func navigateToMainApp() {
        let tabBarController = UITabBarController()
        
        // Setup your tab bar controller the same way as in SceneDelegate
        let foodListVC = UINavigationController(rootViewController: FoodListViewController())
        foodListVC.tabBarItem = UITabBarItem(title: "Food Menu", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let groupsVC = UINavigationController(rootViewController: GroupsViewController())
        groupsVC.tabBarItem = UITabBarItem(title: "My Groups", image: UIImage(systemName: "folder"), tag: 1)
        
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 2)
        
        let orderHistoryVC = UINavigationController(rootViewController: OrderHistoryViewController())
        orderHistoryVC.tabBarItem = UITabBarItem(title: "Orders", image: UIImage(systemName: "clock.fill"), tag: 3)
        
        tabBarController.viewControllers = [foodListVC, groupsVC, favoritesVC, orderHistoryVC]
        
        // Replace the root view controller with animation
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = tabBarController
            UIView.transition(with: window, 
                              duration: 0.3, 
                              options: .transitionCrossDissolve, 
                              animations: nil, 
                              completion: nil)
        }
    }
}