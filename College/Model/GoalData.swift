//
//  GoalData.swift
//  College
//
//  Created by Trent Callan on 10/26/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

import UIKit
import Charts
import Firebase

class GoalData: NSObject {

    var goal: String
    var goalTitle: String
    var dateCreated: String
    var frequencyCompleted: Double = 0
    var frequencyIncompleted: Double = 0
    var pieChartData = PieChartData()
    
    var ref: DatabaseReference!
    var goalRef: DatabaseReference!
    var userID: String!
    
    init(goal: String, goalTitle: String, dateCreated: String, frequencyCompleted: Double, frequencyIncompleted: Double) {
        self.goal = goal
        self.goalTitle = goalTitle
        self.frequencyCompleted = frequencyCompleted
        self.frequencyIncompleted = frequencyIncompleted
        self.dateCreated = dateCreated
        
        ref = Database.database().reference()
        goalRef = ref.child("goals").child(goal)
        userID = Auth.auth().currentUser?.uid

    }
    
    func getFullDate() -> Date {
        let date: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        if let tempDate = dateFormatter.date(from: dateCreated) {
            date = tempDate
        } else {
            date = Date()
        }
        return date
    }
    
    func getFormattedDateString() -> String {
        var dateString: String
        let date = getFullDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"

        if let tempDate = dateFormatter.string(for: date) {
            dateString = tempDate
        } else {
            dateString = dateCreated
        }
        return dateString
    }
    
    func setPieChartEntries() {
        var dataEntries: [PieChartDataEntry] = []
        let dataEntry1 = PieChartDataEntry(value: frequencyCompleted, label: "Completed", data: "Completed" as AnyObject)
        dataEntries.append(dataEntry1)
        let dataEntry2 = PieChartDataEntry(value: frequencyIncompleted, label: "Incompleted", data: "Incompleted" as AnyObject)
        dataEntries.append(dataEntry2)
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        var colors: [UIColor] = []
        colors.append(UIColor.green)
        colors.append(UIColor.red)
        pieChartDataSet.colors = colors
    }
    
    func setGoalData() {
        ref.child("users").child(userID!).child("goals").child(goal).setValue(true)
        goalRef.child("type").setValue(goalTitle)
        goalRef.child("date").setValue(dateCreated)
        goalRef.child("freqCompleted").setValue("\(frequencyCompleted)")
        goalRef.child("freqIncompleted").setValue("\(frequencyIncompleted)")
        goalRef.child("datesCompleted").setValue(true)
        goalRef.child("datesIncompleted").setValue(true)
        goalRef.child("dates").child(dateCreated).setValue(false)
    }
    
    func setFreqeuncies(completed: Double, incompleted: Double) {
        self.frequencyIncompleted = incompleted
        self.frequencyCompleted = completed
        goalRef.child("freqIncompleted").setValue("\(incompleted)")
        goalRef.child("freqCompleted").setValue("\(completed)")
        setPieChartEntries()
    }
    
    func incrementCompleted() {
        self.frequencyCompleted += 1
        goalRef.child("freqCompleted").setValue("\(frequencyCompleted)")
        setPieChartEntries()
    }
    
    func incrementIncomplete() {
        self.frequencyIncompleted += 1
        goalRef.child("freqIncompleted").setValue("\(frequencyIncompleted)")
        setPieChartEntries()
    }
    
}
