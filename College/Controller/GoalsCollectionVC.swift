//
//  GoalsCollectionVC.swift
//  College
//
//  Created by Trent Callan on 10/24/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

import UIKit
import Firebase

class GoalsCollectionVC: UICollectionViewController {
    
    var ref: DatabaseReference!
    var user: User!
    var userID: String!
    var username: String!
    var goals: [GoalData] = []
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? GoalsFlowLayout {
            layout.delegate = self
        }
        
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
        
        //getGoals()
        getAllGoals()
        group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }

    func getAllGoals() {
        group.enter()
        self.ref.child("users").child(self.userID!).child("goals").observeSingleEvent(of: .value, with: { (snapshot1) in
            if let goalDict = snapshot1.value as? NSDictionary {
                for goal in goalDict.allKeys {
                    if let goalString = goal as? String {
                        self.group.enter()
                        self.ref.child("goals").child(goalString).observeSingleEvent(of: .value, with: { (snapshot2) in
                            let dict = snapshot2.value as! NSDictionary
                            let goalType = dict["type"] as! String
                            let date = dict["date"] as! String
                            let freqCompleted = dict["freqCompleted"] as! String
                            let freqIncompleted = dict["freqIncompleted"] as! String
                            let goal = GoalData(goal: goalString, goalTitle: goalType, dateCreated: date, frequencyCompleted: Double(freqCompleted)!, frequencyIncompleted: Double(freqIncompleted)!)
                            goal.setPieChartEntries()
                            self.goals.append(goal)
                            
                            // Sorts the goals by descending order by DATE in goalData model
                            self.goals = self.goals.sorted(by: {
                                $0.getFullDate().compare($1.getFullDate()) == .orderedDescending
                            })
                            self.group.leave()
                        })
                    }
                }
                self.group.leave()
            }
        })
    }
    
    
//    func getGoalsOfType(goalType: String) {
//        group.enter()
//        self.ref.child("users").child(self.userID!).child("goals").observeSingleEvent(of: .value, with: { (snapshot1) in
//            if let goalDict = snapshot1.value as? NSDictionary {
//                for goal in goalDict.allKeys {
//                    if let goalString = goal as? String {
//                        self.group.enter()
//                        self.ref.child("goals").child(goalString).observeSingleEvent(of: .value, with: { (snapshot2) in
//                            let dict = snapshot2.value as! NSDictionary
//                            let goalTypeFromDict = dict["type"] as! String
//                            if(goalTypeFromDict == goalType) {
//                                let date = dict["date"] as! String
//                                let freqCompleted = dict["freqCompleted"] as! String
//                                let freqIncompleted = dict["freqIncompleted"] as! String
//                                let goal = GoalData(goal: goalString, goalTitle: goalTypeFromDict, dateCreated: date, frequencyCompleted: Double(freqCompleted)!, frequencyIncompleted: Double(freqIncompleted)!)
//                                goal.setPieChartEntries()
//                                self.goals.append(goal)
//
//                                // Sorts the goals by descending order by DATE in goalData model
//                                self.goals = self.goals.sorted(by: {
//                                    $0.getFullDate().compare($1.getFullDate()) == .orderedDescending
//                                })
//                            }
//                            self.group.leave()
//                        })
//                    }
//                }
//                self.group.leave()
//            }
//        })
//    }
    
    @objc func addGoal() {
        
        let screen = UIScreen.main.bounds
        let navBarHeight = navigationController?.navigationBar.bounds.height ?? 0
        let viewBounds = self.view.bounds
        let blurrEffect = UIBlurEffect(style: .extraLight)
        let blurryView = UIVisualEffectView(effect: blurrEffect)
        blurryView.frame = CGRect(x: 0, y: 0, width: viewBounds.width, height: viewBounds.height)
        blurryView.tag = 100
        blurryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blurryViewTapped)))
        
        let selectorView = GoalTypeChoiceView(frame: CGRect(x: screen.width-160-12+8, y: navBarHeight+72, width: 160, height: 160))
        selectorView.delegate = self
        selectorView.tag = 101
        
        let triangle = triangleView(frame: CGRect(x: screen.width-16-28, y: navBarHeight+48, width: 32, height: 24))
        triangle.backgroundColor = UIColor.clear
        triangle.tag = 102
        
        blurryView.alpha = 0.0
        selectorView.alpha = 0.0
        triangle.alpha = 0.0
        self.view.addSubview(blurryView)
        self.view.addSubview(selectorView)
        self.view.addSubview(triangle)

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            blurryView.alpha = 1.0
            selectorView.alpha = 1.0
            triangle.alpha = 1.0
        })

    }
    
    @objc func blurryViewTapped() {
        removeAddGoalViews()
    }
    
    func removeAddGoalViews() {
        for index in 100...103 {
            if let viewToRemove = self.view.viewWithTag(index) {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    viewToRemove.alpha = 0
                }) { _ in
                    viewToRemove.removeFromSuperview()
                }
            }
        }
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error logging out")
        }
        navigationController?.popToRootViewController(animated: true)
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

extension GoalsCollectionVC: GoalsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightforPieChart indexPath:IndexPath) -> CGFloat {

        return 300
    }
}

extension GoalsCollectionVC : GoalTypeViewProtocol {
    func buttonTapped(goalType: String) {
        // When a goal type was tapped
        
        // Add place to enter goal description
        let viewBounds = self.view.bounds
        let goalViewWidth = (2*(viewBounds.width/3))
        let goalViewHeight = (viewBounds.height/4)
        let goalView = GoalDescriptionView(frame: CGRect(x: viewBounds.size.width/2 - goalViewWidth/2, y: viewBounds.size.height/2 - goalViewHeight/2, width: goalViewWidth, height: goalViewHeight))
        goalView.delegate = self
        goalView.goalTypeLabel.text = goalType
        goalView.tag = 103
        
        goalView.alpha = 0.0
        self.view.addSubview(goalView)
        // Get rid of views and add the new view
        if let viewWithTag1 = self.view.viewWithTag(101), let viewWithTag2 = self.view.viewWithTag(102) {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                viewWithTag1.alpha = 0.0
                viewWithTag2.alpha = 0.0
                goalView.alpha = 1.0
            }) { _ in
                viewWithTag1.removeFromSuperview()
                viewWithTag2.removeFromSuperview()
                
            }
        }
        
    }
}

extension GoalsCollectionVC : GoalDescriptionViewProtocol {
    func doneButtonTapped(goalDescription: String, goalType: String) {
        
        // Get rid of views
        if let viewWithTag1 = self.view.viewWithTag(100), let viewWithTag2 = self.view.viewWithTag(103) {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
                viewWithTag1.alpha = 0
                viewWithTag2.alpha = 0
            }) { _ in
                viewWithTag1.removeFromSuperview()
                viewWithTag2.removeFromSuperview()
            }
        }
        
        // Create vars for a GoalData Entry
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        let todaysDate = dateFormatter.string(from: date)
        let goal = GoalData(goal: goalDescription, goalTitle: goalType, dateCreated: todaysDate, frequencyCompleted: 0, frequencyIncompleted: 0)
        // Set up for collection view
        goal.setGoalData()
        goal.setPieChartEntries()
        
        // Animate addition of new entry
        self.goals.insert(goal, at: 0)
        let indexPath = IndexPath(
            item: 0,
            section: 0
        )
        
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: [indexPath])
        }, completion: nil)
        
    }
    
    func cancelButtonTapped() {
        removeAddGoalViews()
    }
    
}
