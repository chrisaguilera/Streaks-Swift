//
//  ViewController.swift
//  Streaks
//
//  Created by Chris Aguilera on 9/10/18.
//  Copyright © 2018 Chris Aguilera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let eventsModel = EventsModel.sharedModel
    var selectedCellSection: Int?
    var epvc: EventPageViewController!

    override func viewDidLoad() {
        // Loop through all events (?)
        self.startTimer()
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventsModel.numberOfEvents()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let event = eventsModel.events[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default Cell", for: indexPath) as! EventTableViewCell
        
        cell.event = event
        
        cell.completionHandler = { () in
            tableView.reloadData()
        }
        
        cell.updateTableViewCell()
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCellSection = indexPath.section
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: EventPageViewController.self) {
            
            epvc = segue.destination as? EventPageViewController
            
            epvc.event = eventsModel.events[selectedCellSection!]
            
            // TO-DO: Check if deadline(s) has been reached before loading EPVC
            
            epvc.completionHandler = { () in
                
                print("Event Page View Controller's CH - Message from VC")
                
                // Update corresponding Event Table View Cell
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.selectedCellSection!)) as! EventTableViewCell
                cell.updateTableViewCell()
                
                // Reload Table View
                self.tableView.reloadData()
            }
            
        } else if segue.destination.isKind(of: AddEventViewController.self) {
            let aevc = segue.destination as! AddEventViewController
            aevc.completionHandler = { () in
                self.tableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func startTimer() {
        
        print("Timer started")
        
        let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            
            for event in EventsModel.sharedModel.events {
                if event.hasDeadlineBeenReached() {
                    
                    print("Deadline has been reached for \(event.name)... Deadline: \(event.deadlineDate.description) CompRate: \(event.completionRate)")
                    
                    // Update Table View Cells
                    self.tableView.reloadData()
                    
                    // Update Event Page
                    if self.epvc != nil {
                        self.epvc.updateEventPage()
                    } else {
                        print("EPVC is nil")
                    }
                    
                    // Save Model (Why not do this first?)
                    EventsModel.sharedModel.save()
                }
            }
        }
        
        // Fire timer immediately then at intervals
        timer.fire()
    }

}

