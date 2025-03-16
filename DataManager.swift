import Foundation
import Combine

class DataManager {
    static let shared = DataManager()
    
    private let TAX_RATE: Double = 0.13 // 13% tax rate
    
    // Order history
    private var orderHistory: [Int: [String: [FoodItem]]] = [:]
    private var nextOrderId: Int = 1
    
    // Use subjects to publish changes
    private var foodGroupsSubject = CurrentValueSubject<[String: [FoodItem]], Never>([:])
    var foodGroupsPublisher: AnyPublisher<[String: [FoodItem]], Never> {
        return foodGroupsSubject.eraseToAnyPublisher()
    }
    
    // Favorites publisher
    private var favoritesSubject = CurrentValueSubject<[FoodItem], Never>([])
    var favoritesPublisher: AnyPublisher<[FoodItem], Never> {
        return favoritesSubject.eraseToAnyPublisher()
    }
    
    // Orders publisher
    private var ordersSubject = CurrentValueSubject<[Int: [String: [FoodItem]]], Never>([:])
    var ordersPublisher: AnyPublisher<[Int: [String: [FoodItem]]], Never> {
        return ordersSubject.eraseToAnyPublisher()
    }
    
    // Map to store food groups (groupName -> List of FoodItems)
    private var foodGroups: [String: [FoodItem]] = [:] {
        didSet {
            foodGroupsSubject.send(foodGroups)
        }
    }
    
    // Sample food items
    var foodItems: [FoodItem] = [
        FoodItem(id: 1, name: "Pizza", price: 12.99),
        FoodItem(id: 2, name: "Burger", price: 8.99),
        FoodItem(id: 3, name: "Sushi", price: 15.99),
        FoodItem(id: 4, name: "Pasta", price: 10.99),
        FoodItem(id: 5, name: "Salad", price: 7.99),
        FoodItem(id: 6, name: "Ice Cream", price: 4.99),
        FoodItem(id: 7, name: "Sandwich", price: 6.99),
        FoodItem(id: 8, name: "Taco", price: 3.99)
    ]
    
    private init() {
        // Initialize with an empty "Favorites" group
        foodGroups["Favorites"] = []
    }
    
    // Create an empty group
    func createEmptyGroup(groupName: String) {
        guard !groupName.isEmpty, !foodGroups.keys.contains(groupName) else { return }
        
        foodGroups[groupName] = []
    }
    
    // Add food item to a group
    func addToGroup(_ foodItem: FoodItem, groupName: String = "Favorites", quantity: Int = 1) {
        // If group doesn't exist, create it
        if foodGroups[groupName] == nil {
            foodGroups[groupName] = []
        }
        
        // Add item to group (add multiple times based on quantity)
        var group = foodGroups[groupName] ?? []
        for _ in 0..<quantity {
            group.append(foodItem)
        }
        foodGroups[groupName] = group
    }
    
    // Remove food item from a group
    func removeFromGroup(_ foodItem: FoodItem, groupName: String) {
        guard var group = foodGroups[groupName] else { return }
        
        // Remove the item (all instances)
        group.removeAll { $0.id == foodItem.id }
        
        // If group is empty and not the Favorites group, consider removing the group
        if groupName != "Favorites" && group.isEmpty {
            foodGroups.removeValue(forKey: groupName)
        } else {
            foodGroups[groupName] = group
        }
    }
    
    // Get all groups
    func getGroups() -> [String] {
        return Array(foodGroups.keys)
    }
    
    // Get items in a group
    func getItemsInGroup(_ groupName: String) -> [FoodItem] {
        return foodGroups[groupName] ?? []
    }
    
    // Calculate subtotal for a group (before tax)
    func calculateSubtotal(groupName: String) -> Double {
        let items = foodGroups[groupName] ?? []
        return items.reduce(0) { $0 + $1.price }
    }
    
    // Calculate total with tax for a group
    func calculateTotalWithTax(groupName: String) -> Double {
        let subtotal = calculateSubtotal(groupName: groupName)
        return subtotal * (1 + TAX_RATE)
    }
    
    // Remove an entire group
    func removeGroup(_ groupName: String) {
        // Don't allow removing the Favorites group
        if groupName != "Favorites" {
            foodGroups.removeValue(forKey: groupName)
        }
    }
    
    // Rename a group
    func renameGroup(oldName: String, newName: String) {
        guard oldName != "Favorites",
              !foodGroups.keys.contains(newName),
              !newName.isEmpty,
              let group = foodGroups[oldName] else { return }
        
        foodGroups[newName] = group
        foodGroups.removeValue(forKey: oldName)
    }
    
    // Toggle favorite status for a food item
    func toggleFavorite(foodItemId: Int) {
        for i in 0..<foodItems.count {
            if foodItems[i].id == foodItemId {
                foodItems[i].isFavorite.toggle()
                favoritesSubject.send(getFavoriteItems())
                break
            }
        }
    }
    
    // Get all favorite food items
    func getFavoriteItems() -> [FoodItem] {
        return foodItems.filter { $0.isFavorite }
    }
    
    // Place an order - save current groups to order history
    func placeOrder() -> Int {
        let orderId = nextOrderId
        nextOrderId += 1
        
        // Filter out Favorites group for the order
        var orderGroups: [String: [FoodItem]] = [:]
        for (key, value) in foodGroups {
            if key != "Favorites" && !value.isEmpty {
                orderGroups[key] = value
            }
        }
        
        // Only save if there are actual items
        if !orderGroups.isEmpty {
            orderHistory[orderId] = orderGroups
            ordersSubject.send(orderHistory)
            
            // Clear all groups except Favorites
            let favoritesGroup = foodGroups["Favorites"]
            foodGroups = ["Favorites": favoritesGroup ?? []]
        }
        
        return orderId
    }
    
    // Get order history
    func getOrderHistory() -> [Int: [String: [FoodItem]]] {
        return orderHistory
    }
    
    // Get a specific order
    func getOrder(_ orderId: Int) -> [String: [FoodItem]]? {
        return orderHistory[orderId]
    }
}