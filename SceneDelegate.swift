import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create window
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
       
        if let statusBarManager = windowScene.statusBarManager {
            window.windowScene?.statusBarManager?.statusBarStyle = .lightContent
        }
        
        // Create the main tab controller
        let mainTabController = UITabBarController()
        
        // Create view controllers for tabs
        let foodListVC = UINavigationController(rootViewController: FoodListViewController())
        foodListVC.tabBarItem = UITabBarItem(title: "Food Items", image: UIImage(systemName: "list.bullet"), tag: 0)
        
       
        ThemeConstants.applyAndroidStylingToNavigationBar(foodListVC.navigationBar)
        
        let groupsVC = UINavigationController(rootViewController: GroupsViewController())
        groupsVC.tabBarItem = UITabBarItem(title: "My Groups", image: UIImage(systemName: "folder"), tag: 1)
        
       
        ThemeConstants.applyAndroidStylingToNavigationBar(groupsVC.navigationBar)
        
        
        ThemeConstants.applyAndroidStylingToTabBar(mainTabController.tabBar)
        
        // Set up the tab controller
        mainTabController.viewControllers = [foodListVC, groupsVC]
        
        // Set the tab controller as root
        window.rootViewController = mainTabController
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}