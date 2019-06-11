//
//  AddRecipeVC.swift
//  CollegeOrganization
//
//  Created by Trent Callan on 10/23/17.
//  Copyright © 2017 Trent Callan. All rights reserved.
//

import UIKit

class AddRecipeVC: UIViewController {
    
    var ingredients = [String]()
    var amount = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBOutlet weak var TitleField: UITextField!
    
    @IBAction func AddIngredient(_ sender: Any) {
        
        let ac1 = UIAlertController(title: "Add Ingredient and Amount", message: nil, preferredStyle: .alert)
        ac1.addTextField()
        ac1.addTextField()
        
        ac1.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac1.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac1] _ in
            
            let newIngredient = ac1.textFields![0].text!
            self.ingredients.append(newIngredient)
            
            let newAmount = ac1.textFields![1].text!
            self.amount.append(newAmount)
            
            self.setUpList()
        })
        
        present(ac1, animated: true)
        
        
    }
    
    func setUpList() {
        
        let width = UIScreen.main.bounds.width
        var inc = 0
        
        for item in ingredients {
            let newIngredient = UILabel(frame: CGRect(x: 10, y: (((inc*30)+200)+(inc*5)), width: Int(width - 120), height: 30))
            let newIngredientAmount = UILabel(frame: CGRect(x: Int(width - 110), y: (((inc*30)+200)+(inc*5)), width: 100, height: 30))
            newIngredient.text = item
            newIngredient.textAlignment = .left
            newIngredientAmount.textAlignment = .right
            newIngredientAmount.text = amount[inc]
            self.view.addSubview(newIngredient)
            self.view.addSubview(newIngredientAmount)
            inc+=1
        }
        
    }
    
    var Recipes: RecipesTVC!
    
    @IBAction func Done(_ sender: Any) {
        Recipes.getData(title: TitleField.text!, ingredients: self.ingredients, amount: self.amount)
        dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    


}
