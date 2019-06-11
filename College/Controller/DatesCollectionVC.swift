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
    var dates: [String] = []
    let format = DateFormatter()
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    var datesDelegate: DatesDelegate?
    var calendar: CalendarModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar = CalendarModel(date: goal.getFullDate())
        dates = (calendar?.getArrayOfDateStrings())!
        
        format.dateFormat = "MMM dd, yyyy"
        
        self.collectionView?.allowsSelection = true
        self.collectionView?.allowsMultipleSelection = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneButton

    }
    
    // Sets up the datesDictionary with values from database
    func getDates() {
        // Single time event call
        let goalref = ref.child("goals").child(goal.goal)
        goalref.child("dates").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let dateStrings = dict.allKeys as! [String]
                let completionBoolean = dict.allValues as! [Bool]
                for i in 0...dateStrings.count-1 {
                    let dateString = dateStrings[i]
                    let completion = completionBoolean[i]
                    self.datesDictionary[dateString] = completion
                }
                if(self.dates.count > dateStrings.count) {
                    for index in dateStrings.count...self.dates.count-1 {
                        self.datesDictionary[self.dates[index]] = false
                    }
                }
                self.collectionView?.reloadData()
            }
        })
    }

    // Calculates frequencies completed and incompleted and then set the values in the database
    @objc func done() {
        var freqCompleted: Double = 0
        var freqIncompleted: Double = 0
        for date in dates {
            if let completion = datesDictionary[date] {
                completion ? (freqCompleted+=1) : (freqIncompleted+=1)
                ref.child("goals").child(goal.goal).child("dates").child(date).setValue(completion)
            }
        }
        goal.setFreqeuncies(completed: freqCompleted, incompleted: freqIncompleted)
        // Reload the views in previous controller so frequencies with update with the graphs
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
        cell.date.text = day
        let date = month.fullDays[indexPath.row]
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
        if let cell = collectionView.cellForItem(at: indexPath) as? dateCell {
            let month = calendar.months[indexPath.section]
            let date = month.fullDays[indexPath.row]
            setCellBackgroundAndUpdateDictionary(cell: cell, date: date)

        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? dateCell {
            let month = calendar.months[indexPath.section]
            let date = month.fullDays[indexPath.row]
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
