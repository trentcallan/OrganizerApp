//
//  GroceryListTVC.swift
//  CollegeOrganization
//
//  Created by Trent Callan on 10/11/17.
//  Copyright © 2017 Trent Callan. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class GroceryListTVC: UITableViewController, UITabBarControllerDelegate {

    var groceryItems = [GroceryItem]()
    var items = [GroceryItem]()
    var ref: DatabaseReference!
    var userID: String!
    var username: String!
    var heightForSectionHeader: CGFloat = 64
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        userID = Auth.auth().currentUser?.uid
        username = Auth.auth().currentUser?.displayName
        getGroceryItems()
        
        // Delegate tabBar in order to call didSelect an item for updating purposes
        self.tabBarController?.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false

        // Set up navigation bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroceryItem))
        navigationItem.title = "Grocery List"
    }
    
    // Calls once and appends grocery items
    func getGroceryItems() {
        self.groceryItems.removeAll()
        self.ref = Database.database().reference()
        self.ref.child("users").child(userID).child("grocery items").observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let categories = dict.allKeys as! [String]
                for category in categories {
                    let categoryDict = dict[category] as! NSDictionary
                    let items = categoryDict.allKeys as! [String]
                    let quantities = categoryDict.allValues as! [String]
                    let groceryModel = GroceryItem(items: items, category: category, quantities: quantities)
                    self.groceryItems.append(groceryModel)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        // Update the grocery items if this controllers tab is clicked on
        if tabBarIndex == 2 {
            getGroceryItems()
        }
    }

    @objc func addGroceryItem() {
        let ac = UIAlertController(title: "Add A Grocery Item", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Grocery Item"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "Category"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "Quantity"
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
            
            // Default value is ""
            let newItem = ac.textFields![0].text!
            let category = ac.textFields![1].text!
            let quantity = ac.textFields![2].text!
            // If one field isn't entered
            if(newItem == "" || category == "" || quantity == "") {
                return
            }
            
            self.ref = Database.database().reference()
            self.ref.child("users").child(self.userID).child("grocery items").child(category).child(newItem).setValue(quantity)
            self.getGroceryItems()
        })
        present(ac, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groceryItems.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: heightForSectionHeader))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height))
        label.text = groceryItems[section].category.uppercased()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        headerView.addSubview(label)
        
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForSectionHeader
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath) as! GroceryCell
        let category = groceryItems[indexPath.section]
        let groceryItem = category.items[indexPath.row]
        let quantitiy = category.quantities[indexPath.row]
        cell.groceryItem.text = groceryItem + " " + quantitiy
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = groceryItems[indexPath.section]
            let groceryItem = category.items[indexPath.row]
            // Remove from database
            self.ref.child("users").child(self.userID).child("grocery items").child(category.category).child(groceryItem).removeValue()
            // Remove items and their quantity
            category.items.remove(at: indexPath.row)
            category.quantities.remove(at: indexPath.row)
            // If the section if empty delete the whole sections
            if(category.items.count == 0 && category.quantities.count == 0) {
                groceryItems.remove(at: indexPath.section)
                let indexSet = IndexSet(integer: indexPath.section)
                tableView.deleteSections(indexSet, with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

}
