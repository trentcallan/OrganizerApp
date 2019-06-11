//
//  RecipesTVC.swift
//  CollegeOrganization
//
//  Created by Trent Callan on 10/21/17.
//  Copyright © 2017 Trent Callan. All rights reserved.
//

import UIKit

class RecipesTVC: UITableViewController {

    var recipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipe))
        navigationItem.title = "Recipes"
    }
    
    @objc func addRecipe() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addRecipe") as! AddRecipeVC
        present(vc, animated: true) {
            vc.Recipes = self
        }
    }
    
    func getData(title: String, ingredients: [String], amount: [String]) {
        
        let newRecipe = Recipe(title: title, ingredients: ingredients, amount: amount)
        recipes.append(newRecipe)
        save()
        self.updateRecipes()
        self.tableView.reloadData()
    }

    func save() {
        //right now this will save all of recipes under just the tag ingredients
        let savedData = NSKeyedArchiver.archivedData(withRootObject: recipes)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "ingredients")
    }
    
    func updateRecipes() {
        
        let defaults = UserDefaults.standard
        if let savedItems = defaults.object(forKey: "ingredients") as? Data {
            recipes = NSKeyedUnarchiver.unarchiveObject(with: savedItems) as! [Recipe]
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = recipes[indexPath.row].ingredients.count
        
        if(count == 0) {
            return CGFloat(0)
        } else {
            return CGFloat(((count*30)+80)+(count*5))
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.updateCell(recipe: recipe)
        cell.Title.text = recipe.title.uppercased()
        cell.selectionStyle = .none

        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.recipes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            save()
            updateRecipes()
        }
    }
    
}
