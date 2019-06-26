//
//  DatesCollectionVC.swift
//  College
//
//  Created by Trent Callan on 11/1/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

import UIKit
import Firebase

protocol DatesDelegate {
    func reloadCollectionView()
}

class DatesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var goal: GoalData!
    var datesDictionary: [String : Bool] = [:]
    let format = DateFormatter()
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    var datesDelegate: DatesDelegate?
    var calendar: CalendarModel! {
        didSet {
            populateDatesDictionary()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        format.dateFormat = "MMM dd, yyyy"
        
        self.collectionView?.allowsSelection = true
        self.collectionView?.allowsMultipleSelection = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneButton

        // When the database call to get dates is done the main thread will update the collection view
        getDatesGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Called when the back button is clicked
        if self.isMovingFromParent {
            done()
        }
    }
    
    func populateDatesDictionary() {
        for month in calendar.months {
            for day in month.days {
                datesDictionary[day.date.fullDay] = false
            }
        }
    }
    
    let getDatesGroup = DispatchGroup()
    // Sets up the datesDictionary with values from database
    func getDates() {
        // Single time event call
        let goalref = ref.child("goals").child(goal.goal)
        getDatesGroup.enter()
        goalref.child("dates").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let dateStrings = dict.allKeys as! [String]
                let completionBoolean = dict.allValues as! [Bool]
                for i in 0...dateStrings.count-1 {
                    if(completionBoolean[i]) {
                        let dateString = dateStrings[i]
                        self.datesDictionary[dateString] = true
                    }
                }
            }
            self.getDatesGroup.leave()
        })
    }

    // Calculates frequencies completed and incompleted and then set the values in the database
    @objc func done() {
        var freqCompleted: Double = 0
        var freqIncompleted: Double = 0
        for month in calendar.months {
            for day in month.days {
                let date = day.date.fullDay
                if let completion = datesDictionary[date] {
                    completion ? (freqCompleted+=1) : (freqIncompleted+=1)
                    ref.child("goals").child(goal.goal).child("dates").child(date).setValue(completion)
                }
            }
        }
        goal.setFreqeuncies(completed: freqCompleted, incompleted: freqIncompleted)
        // Reload the views in previous controller so frequencies will update with the graphs
        datesDelegate?.reloadCollectionView()
        self.navigationController?.popViewController(animated: true)
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calendar.months.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Register the reusable view with a reuse identifier
        collectionView.register(MonthHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as! MonthHeaderCollectionView
        let text = calendar.months[indexPath.section].name
        headerView.label.text = text
        return headerView
    }
    
    // Size of header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendar.months[section].days.count
    }
    
    // Size of days
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/5, height: collectionView.frame.size.width/5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! dateCell
        let month = calendar.months[indexPath.section]
        let day = month.days[indexPath.row]
        let dateString = day.dateString
        cell.date.text = dateString
        let date = day.date.fullDay
        // Set colors for days completed or not
        if let completion = datesDictionary[date] {
            if(completion) {
                cell.backgroundColor = UIColor.green
            } else {
                cell.backgroundColor = UIColor.red
            }
        } else {
            // If there is no entry then set it to not completed
            cell.backgroundColor = UIColor.red
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTouchItemAt(indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didTouchItemAt(indexPath: indexPath)
    }
    
    // When the cell is touch (selected or deselected)
    func didTouchItemAt(indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? dateCell {
            let month = calendar.months[indexPath.section]
            let date = month.days[indexPath.row].date.fullDay
            setCellBackgroundAndUpdateDictionary(cell: cell, date: date)
        }
    }
    
    // Update cell color and dictionary based on users selection
    func setCellBackgroundAndUpdateDictionary(cell: dateCell, date: String) {
        if(cell.backgroundColor == UIColor.green) {
            cell.backgroundColor = UIColor.red
            datesDictionary[date] = false
        } else {
            cell.backgroundColor = UIColor.green
            datesDictionary[date] = true
        }
    }

}
