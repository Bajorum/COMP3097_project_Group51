import Foundation
import Combine

class DataManager {
    static let shared = DataManager()
    
    private let TAX_RATE: Double = 0.13 // 13% tax rate
    
    // Use a subject to publish changes in food groups
    private var foodGroupsSubject = CurrentValueSubject<[String: [FoodItem]], Never>([:])
    var foodGroupsPublisher: AnyPublisher<[String: [FoodItem]], Never> {
        return foodGroupsSubject.eraseToAnyPublisher()
    }
    
    // Map to store food groups (groupName -> List of FoodItems)
    private var foodGroups: [String: [FoodItem]] = [:] {
        didSet {
            foodGroupsSubject.send(foodGroups)
        }
    }
    
    // Sample food items
    let foodItems: [FoodItem] = [
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
    func addToGroup(_ foodItem: FoodItem, groupName: String = "Favorites") {
        // If group doesn't exist, create it
        if foodGroups[groupName] == nil {
            foodGroups[groupName] = []
        }
        
        // Add item to group (create a new array to trigger didSet)
        var group = foodGroups[groupName] ?? []
        group.append(foodItem)
        foodGroups[groupName] = group
    }
    
    // Remove food item from a group
    func removeFromGroup(_ foodItem: FoodItem, groupName: String) {
        guard var group = foodGroups[groupName] else { return }
        
        // Remove the item
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
}