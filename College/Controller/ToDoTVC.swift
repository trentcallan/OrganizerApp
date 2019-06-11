//
//  ToDoTVC.swift
//  CollegeOrganization
//
//  Created by Trent Callan on 10/23/17.
//  Copyright © 2017 Trent Callan. All rights reserved.
//

import UIKit
import Firebase

class ToDoTVC: UITableViewController {

    var toDoList = [ToDoModel]()
    var ref: DatabaseReference!
    var user: User!
    var userID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        user = Auth.auth().currentUser
        userID = Auth.auth().currentUser?.uid
        getToDos()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editing))
        navigationItem.title = "To Do List"
        navigationController?.navigationBar.backgroundColor = UIColor.lightGray
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 800;
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.isEditing = false
        self.tableView.allowsSelection = false
    }
    
    func getToDos() {
        toDoList.removeAll()
        ref.child("users").child(userID!).child("to do list").observeSingleEvent(of: .value) { (snapshot) in
            //let ID = snapshot.key
            let IDdict = snapshot.value as! NSDictionary
            for ID in IDdict.allKeys as! [String] {
                let dict = IDdict[ID] as! NSDictionary
                let toDo = dict["to do"] as! String
                let priority = dict["priority"] as! String
                let toDoModel = ToDoModel(ID: ID, toDo: toDo, priority: priority)
                self.toDoList.append(toDoModel)
                self.toDoList = self.toDoList.sorted(by: {
                    $0.priority.compare($1.priority) == .orderedAscending
                })
            }

            self.tableView.reloadData()
        }
        
    }
    
    @objc func editing() {
        if(tableView.isEditing) {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }

    @objc func addToDo() {
        
        let ac = UIAlertController(title: "Add a To Do", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "To Do"
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
            
            // Default value is ""
            let newToDo = ac.textFields![0].text!
            // If no value is entered
            if(newToDo == "") {
                return
            }
            //self.ref.child("users").child(self.userID!).child("to do list").childByAutoId().setValue(newToDo)
            let toDoRef  = self.ref.child("users").child(self.userID!).child("to do list").childByAutoId()
            toDoRef.child("to do").setValue(newToDo)
            let priority = self.toDoList.count+1
            toDoRef.child("priority").setValue("\(priority)")
            self.getToDos()

        })
        
        present(ac, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDo", for: indexPath) as! toDoCell
        let toDo = toDoList[indexPath.row]
        cell.toDoLabel.text = toDo.toDo
        cell.priorityLabel.text = toDo.priority
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDo = toDoList[indexPath.row]
            // Delete item from database
            ref.child("users").child(userID!).child("to do list").child(toDo.ID).removeValue()
            // Remove from arrays
            toDoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemMoving = self.toDoList[sourceIndexPath.row]
        toDoList.remove(at: sourceIndexPath.row)
        toDoList.insert(itemMoving, at: destinationIndexPath.row)
        for index in 0...toDoList.count-1 {
            let num = index+1
            toDoList[index].priority = String(num)
        }
        tableView.reloadData()
        updatePriorities()
    }
    
    func updatePriorities() {
        for item in toDoList {
            let ID = item.ID
            let toDoRef = self.ref.child("users").child(self.userID!).child("to do list").child(ID)
            toDoRef.child("priority").setValue(item.priority)
        }
    }
    

}
