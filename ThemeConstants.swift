import UIKit

struct ThemeConstants {
    // Primary colors (match Android)
    static let primaryColor = UIColor(red: 0.38, green: 0.0, blue: 0.93, alpha: 1.0) // #6200EE
    static let primaryVariantColor = UIColor(red: 0.22, green: 0.0, blue: 0.7, alpha: 1.0) // #3700B3
    static let secondaryColor = UIColor(red: 0.01, green: 0.85, blue: 0.77, alpha: 1.0) // #03DAC5
    static let secondaryVariantColor = UIColor(red: 0.0, green: 0.53, blue: 0.53, alpha: 1.0) // #018786
    
    // Basic colors
    static let backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0) // #F5F5F5
    static let cardBackgroundColor = UIColor.white
    static let accentColor = UIColor(red: 1.0, green: 0.25, blue: 0.51, alpha: 1.0) // #FF4081
    static let grayColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1.0) // #888888
    static let lightGrayColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0) // #E0E0E0
    
    // Text colors
    static let textPrimaryColor = UIColor.black
    static let textSecondaryColor = UIColor.darkGray
    
    
    static let cardCornerRadius: CGFloat = 8.0
    static let cardElevation: CGFloat = 4.0
    static let standardMargin: CGFloat = 8.0
    static let doubleMargin: CGFloat = 16.0
    
    
    static let headerTextSize: CGFloat = 20.0
    static let primaryTextSize: CGFloat = 18.0
    static let secondaryTextSize: CGFloat = 16.0
    
    /
    static func applyAndroidStylingToNavigationBar(_ navigationBar: UINavigationBar) {
        navigationBar.barTintColor = primaryColor
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
        
        
        navigationBar.isTranslucent = false
        
        // For iOS 15+
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = primaryColor
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    
    static func applyAndroidStylingToTabBar(_ tabBar: UITabBar) {
        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = primaryColor
        
        // For iOS 15+
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
   
    static func createAndroidStyleButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = primaryColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 4
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }
    
    
    static func styleAsAndroidCard(view: UIView) {
        view.backgroundColor = cardBackgroundColor
        view.layer.cornerRadius = cardCornerRadius
        
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
    }
}