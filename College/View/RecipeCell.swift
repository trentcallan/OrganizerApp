//
//  RecipeCell.swift
//  CollegeOrganization
//
//  Created by Trent Callan on 10/21/17.
//  Copyright © 2017 Trent Callan. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var Title: UILabel!
    var recipe: Recipe!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.Title.textAlignment = .center
        self.Title.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.Title.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        
        //adding a line underneath the title
        let frame = self.Title.frame //Frame of view
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: frame.size.height, width: (frame.width+20), height: 1)
        bottomLayer.backgroundColor = UIColor.black.cgColor
        self.Title.layer.addSublayer(bottomLayer)
        
        //adding a line above the title
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0, y: 0, width: (frame.size.width+20), height: 1)
        topLayer.backgroundColor = UIColor.black.cgColor
        self.Title.layer.addSublayer(topLayer)
        
    }
    
    func updateCell(recipe: Recipe!) {
        self.recipe = recipe
        let cellWidth = self.bounds.width
        
        self.contentView.viewWithTag(100)?.removeFromSuperview()
        self.contentView.viewWithTag(99)?.removeFromSuperview()
        self.contentView.viewWithTag(98)?.removeFromSuperview()
        var inc = 0
        //let newView = UIView()
        //let newView : UIView = UIView(frame: CGRect(x: 0.0, y: 30.0, width: cellWidth, height: CGFloat(recipe.ingredients.count*30)))
        //newView.tag = 100
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.tag = 100
        
        self.Title.text = recipe.title
        
        stackView.addArrangedSubview(Title)
        
        for item in recipe.ingredients {
            
            let sView = UIStackView()
            sView.alignment = .center
            sView.distribution = .equalSpacing
            sView.axis = .horizontal
            sView.spacing = 5
            sView.tag = 99
            
            let newIngredient = UILabel()
            /*(frame: CGRect(x: 10, y: (((inc*30)+20)+(inc*5)), width: Int(cellWidth - 120), height: 30))*/
            newIngredient.text = item
            newIngredient.textAlignment = .left
            newIngredient.heightAnchor.constraint(equalToConstant: 30).isActive = true
            newIngredient.widthAnchor.constraint(equalToConstant: (cellWidth - 120)).isActive = true
            
            let newIngredientAmount = UILabel()
            /*(frame: CGRect(x: Int(cellWidth - 110), y: (((inc*30)+20)+(inc*5)), width: 100, height: 30))*/
            newIngredientAmount.textAlignment = .right
            newIngredientAmount.text = recipe.amount[inc]
            newIngredientAmount.heightAnchor.constraint(equalToConstant: 30).isActive = true
            newIngredientAmount.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            sView.addArrangedSubview(newIngredient)
            sView.addArrangedSubview(newIngredientAmount)
            sView.translatesAutoresizingMaskIntoConstraints = false
            
            inc+=1
            
            stackView.addArrangedSubview(sView)
        }
        
        //add buttons at the bottom
        let buttons = addButtons()
        stackView.addArrangedSubview(buttons)
        
        //self.contentView.addSubview(newView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        //stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
    }
    
    func addButtons() -> UIStackView {
        
        let horizontalStack = UIStackView()
        horizontalStack.alignment = .center
        horizontalStack.distribution = .equalSpacing
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 5
        horizontalStack.tag = 98
        
        let addToGrocery = UIButton()
        addToGrocery.showsTouchWhenHighlighted = true
        addToGrocery.addTarget(self, action: #selector(addToGroceryList), for: .touchUpInside)
        addToGrocery.setTitle("Add to Grocery List", for: .normal)
        addToGrocery.setTitleColor(UIColor.black, for: .normal)
        addToGrocery.layer.borderWidth = 2
        addToGrocery.layer.borderColor = UIColor.black.cgColor
        addToGrocery.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addToGrocery.widthAnchor.constraint(equalToConstant: (self.frame.size.width - 120)).isActive = true
        
        let test = UIButton()
        test.showsTouchWhenHighlighted = true
        test.setTitle("test", for: .normal)
        test.setTitleColor(UIColor.black, for: .normal)
        test.layer.borderWidth = 2
        test.layer.borderColor = UIColor.black.cgColor
        test.heightAnchor.constraint(equalToConstant: 30).isActive = true
        test.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        horizontalStack.addArrangedSubview(addToGrocery)
        horizontalStack.addArrangedSubview(test)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        return horizontalStack
        
    }
    
    //update this for the data model
    @objc func addToGroceryList() {
        var groceryItems = [GroceryItem]()
        
        //update
        let defaults = UserDefaults.standard
        if let savedItems = defaults.object(forKey: "item") as? Data {
            groceryItems = NSKeyedUnarchiver.unarchiveObject(with: savedItems) as! [GroceryItem]
        }
        
        //add items
        for item in self.recipe.ingredients {
            let grocery = GroceryItem(items: [item], category: "temp", quantities: ["0"])
            groceryItems.append(grocery)
        }
        
        //save
        let savedData = NSKeyedArchiver.archivedData(withRootObject: groceryItems)
        defaults.set(savedData, forKey: "item")
        
    }
    

}
