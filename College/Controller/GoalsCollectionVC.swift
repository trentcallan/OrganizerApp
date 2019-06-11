//
//  GoalsCollectionVC.swift
//  College
//
//  Created by Trent Callan on 10/24/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

import UIKit
import Firebase

class GoalsCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var ref: DatabaseReference!
    var user: User!
    var userID: String!
    var username: String!
    var goals: [GoalData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.isUserInteractionEnabled = true
        // Set up database
        ref = Database.database().reference()
        user = Auth.auth().currentUser
        userID = Auth.auth().currentUser?.uid
        username = Auth.auth().currentUser?.displayName
        
        // Set up navigation bar buttons
        self.navigationItem.title = "Goals"
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(logout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGoal))
        
        getGoals()
    }

    // Only needed to be called once because a listener is called on the database
    func getGoals() {
        // This will be called whenever a child is added to the specific node in the Firebase database
        self.ref.child("users").child(self.userID!).child("goals").observe(.childAdded, with: { (snapshot) in
            let goalDesc = snapshot.key
            // Storing name of goal under users
            // Then storing all goal info in a different area of database
            self.ref.child("goals").child(goalDesc).observeSingleEvent(of: .value, with: { (snapshot) in
                let dict = snapshot.value as! NSDictionary
                let goalType = dict["type"] as! String
                let date = dict["date"] as! String
                let freqCompleted = dict["freqCompleted"] as! String
                let freqIncompleted = dict["freqIncompleted"] as! String
                let goal = GoalData(goal: goalDesc, goalTitle: goalType, dateCreated: date, frequencyCompleted: Double(freqCompleted)!, frequencyIncompleted: Double(freqIncompleted)!)
                goal.setPieChartEntries()
                self.goals.append(goal)
                
                // Sorts the goals by descending order by DATE in goalData model
                self.goals = self.goals.sorted(by: {
                    $0.getFullDate().compare($1.getFullDate()) == .orderedDescending
                })
                self.collectionView?.reloadData()
            })
        })
        
    }

    @objc func addGoal() {
        
        let ac = UIAlertController(title: "Add a Goal", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Type of Goal"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "Goal"
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
            
            // Default value is ""
            let goalType = ac.textFields![0].text!
            let goalDesc = ac.textFields![1].text!
            // If one field isn't entered
            if(goalType == "" || goalDesc == "") {
                return
            }
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
            let todaysDate = dateFormatter.string(from: date)
            let goal = GoalData(goal: goalDesc, goalTitle: goalType, dateCreated: todaysDate, frequencyCompleted: 0, frequencyIncompleted: 0)
            goal.setGoalData()
            
        })
        
        present(ac, animated: true)

    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error logging out")
        }
        print()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height/2)
    }
    
    // Used for when cell clicked
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.25) {
            if let cell = collectionView.cellForItem(at: indexPath) as? GoalViewCell {
                cell.transform = .init(scaleX: 0.75, y: 0.75)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }
    // When cell is unclicked
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.25) {
            if let cell = collectionView.cellForItem(at: indexPath) as? GoalViewCell {
                cell.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goals.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chartCell", for: indexPath) as! GoalViewCell
        let goal = goals[indexPath.row]
        cell.goalDescription.text = goal.goal
        cell.goalType.text = "\(goal.goalTitle) goal for \(username ?? "")"
        cell.setUpPieChart(chartData: goals[indexPath.row].pieChartData)
        cell.pieChart.chartDescription?.text = "Start Date: \(goal.getFormattedDateString())"
        cell.pieChart.centerText = goal.goalTitle
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goal = goals[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "dates") as! DatesCollectionVC
        // Set the goal and get the dates before pushing new view controller
        vc.goal = goal
        vc.getDates()
        vc.datesDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension GoalsCollectionVC : DatesDelegate {
    
    func reloadCollectionView() {
        self.collectionView?.reloadData()
    }
}
