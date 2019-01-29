//
//  Event.swift
//  Streaks
//
//  Created by Chris Aguilera on 9/10/18.
//  Copyright © 2018 Chris Aguilera. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum EventFrequency: Int, Codable {
    case daily
    case weekly
    case monthly
}

enum TimeInterval: Double, Codable {
    case day = 86400
    case week = 604800
    case month = 2592000
}


class Event: NSObject, Codable {
    
    var name: String
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    var totalNum: Int = 0
    var completedNum: Int = 0
    var completionRate: Double = 0.0
    var prevDeadlineDate: Date
    var deadlineDate: Date
    var missedDeadline: Bool = false
    var requiresLocation: Bool
    var isCompleted: Bool = false
    var frequency: EventFrequency
    var latitude: Double = 0
    var longitude: Double = 0
    var latitudeDelta: Double = 0
    var longitudeDelta: Double = 0
    
    init(withName name: String, withFrequency frequency: EventFrequency, requiresLocation: Bool) {
        
        self.name = name
        self.frequency = frequency
        
        //
        let currentDate = Date()
        print("Current Date when creating: \(currentDate.description)")
//        let calendar = Calendar.current
//        let yearComponent = calendar.component(Calendar.Component.year, from: currentDate)
//        let monthComponent = calendar.component(Calendar.Component.month, from: currentDate)
//        let dayComponent = calendar.component(Calendar.Component.day, from: currentDate)
//        let dateComponents = DateComponents(year: yearComponent, month: monthComponent, day: dayComponent, hour: 23, minute: 59, second: 59)
//        let normalizedCurrentDate = calendar.date(from: dateComponents)!
//
//        if frequency == .daily {
//            deadlineDate = normalizedCurrentDate
//        } else {
//            deadlineDate = Event.deadlineDate(forDate: normalizedCurrentDate, withFrequency: frequency)
//        }
        deadlineDate = Event.deadlineDate(forDate: currentDate, withFrequency: frequency)
        prevDeadlineDate = deadlineDate
        
        self.requiresLocation = requiresLocation
        
        super.init()
    }
    
    class func deadlineDate(forDate date: Date, withFrequency frequency: EventFrequency) -> Date {
        
        var validDate = date
        
        repeat {
            if frequency == .daily {
                validDate = validDate.addingTimeInterval(TimeInterval.day.rawValue)
            } else if frequency == .weekly {
                validDate = validDate.addingTimeInterval(TimeInterval.week.rawValue)
            } else {
                validDate = validDate.addingTimeInterval(TimeInterval.month.rawValue)
            }
        } while validDate.timeIntervalSinceNow <= 0.0
        
        return validDate
    }
    
    class func localTime(forDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    func completeEvent() {
        
        currentStreak += 1
        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }
        totalNum += 1
        completedNum += 1
        completionRate = Double(completedNum)/Double(totalNum)
        isCompleted = true
        prevDeadlineDate = deadlineDate
        deadlineDate = Event.deadlineDate(forDate: deadlineDate, withFrequency: frequency)
    }
    
    func failEvent() {
        
        currentStreak = 0

        var validDate = deadlineDate
        
        // Increment totalNum for all missed deadlines and compute new completionRate value
        repeat {
            if frequency == .daily {
                validDate = validDate.addingTimeInterval(TimeInterval.day.rawValue)
            } else if frequency == .weekly {
                validDate = validDate.addingTimeInterval(TimeInterval.week.rawValue)
            } else {
                validDate = validDate.addingTimeInterval(TimeInterval.month.rawValue)
            }
            
            totalNum += 1
            completionRate = Double(completedNum)/Double(totalNum)
        } while validDate.timeIntervalSinceNow <= 0.0
        
        isCompleted = false
        prevDeadlineDate = deadlineDate
        deadlineDate = Event.deadlineDate(forDate: deadlineDate, withFrequency: frequency)
    }
    
    func description() -> String {
        return "\(name): \n    Current: \(currentStreak) \n    Best: \(bestStreak) \n    Completed Num: \(completedNum) \n    Total Num: \(totalNum) \n    Completion Rate: \(completionRate) \n    Prev Deadline: \(prevDeadlineDate.description) \n    Deadline: \(deadlineDate.description) \n    Requires Location: \(requiresLocation) \n    Comlpeted: \(isCompleted) \n    Frequency: \(frequency)"
    }
    
    func hasDeadlineBeenReached() -> Bool {
        
        var deadlineReached = false
        
        if isCompleted {
            if prevDeadlineDate.timeIntervalSinceNow < 0 {
                
                // Now available for completion again
                isCompleted = false
                
                deadlineReached = true
            }
        } else {
            if deadlineDate.timeIntervalSinceNow < 0 {
                
                // Missed deadline
                failEvent()
                
                deadlineReached = true
            }
        }
        
        return deadlineReached
    }
    
}

