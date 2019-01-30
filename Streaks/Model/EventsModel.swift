//
//  EventsModel.swift
//  Streaks
//
//  Created by Chris Aguilera on 9/12/18.
//  Copyright © 2018 Chris Aguilera. All rights reserved.
//

import UIKit

class EventsModel: NSObject {
    
    static let sharedModel = EventsModel()
    
    var events = [Event]()
    var fileURL: URL
    
    private override init() {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        let documentDirectoryURL = URL(fileURLWithPath: documentDirectoryPath)
        fileURL = documentDirectoryURL.appendingPathComponent("events.plist")
        print("File URL: \(fileURL.absoluteString)")
        
        // For Not-Testing
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {

            // Decode events data from documents into array
            do {
                let jsonDecoder = JSONDecoder()
                let jsonData = try Data(contentsOf: fileURL)
                events = try jsonDecoder.decode([Event].self, from: jsonData)
            } catch {
                print(error)
            }

            for event in events {
                print(event.description())
            }

        } else {
            print("'events.plist' not yet created.")
        }
        
        // For Testing
//        let now = Date()
//        print("Now: \(now)")
//
//        let deadlineDate1 = now.addingTimeInterval(86430)
//        let prevDeadlineDate1 = now.addingTimeInterval(30)
//        let event1 = Event(withName: "Event 2", withFrequency: .daily, requiresLocation: false)
//        event1.currentStreak = 8
//        event1.bestStreak = 8
//        event1.totalNum = 10
//        event1.completedNum = 8
//        event1.completionRate = 8.0/10.0
//        event1.isCompleted = true
//        event1.deadlineDate = deadlineDate1
//        event1.prevDeadlineDate = prevDeadlineDate1
//        events.append(event1)

//        let deadlineDate2 = now.addingTimeInterval(30)
//        let event2 = Event(withName: "Event 2", withFrequency: .daily, requiresLocation: false)
//        event2.currentStreak = 6
//        event2.bestStreak = 9
//        event2.totalNum = 20
//        event2.completedNum = 15
//        event2.completionRate = 15.0/19.0
//        event2.isCompleted = false
//        event2.deadlineDate = deadlineDate2
//        events.append(event2)

        super.init()

    }
    
    func numberOfEvents() -> Int {
        return events.count
    }
    
    func addEvent(_ event: Event) {
        events.append(event)
        save()
    }
    
    func removeEventAtIndex(_ index: Int) {
        events.remove(at: index)
        save()
    }
    
    func save() {
        
        // To-Do: Sort array before saving
        
        // Encode data and save to documents
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(events)
            try jsonData.write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
}
