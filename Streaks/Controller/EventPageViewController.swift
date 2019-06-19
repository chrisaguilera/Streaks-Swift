//
//  EventPageViewController.swift
//  Streaks
//
//  Created by Chris Aguilera on 9/18/18.
//  Copyright © 2018 Chris Aguilera. All rights reserved.
//

import UIKit
import MapKit

class EventPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var event: Event!
    var completionHandler: (() -> Void)!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = event.name
        // Location Manager
        locationManager.delegate = self
        locationManager.distanceFilter = 1.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if event.requiresLocation {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Streak Cell", for: indexPath) as! StreakTableViewCell
            cell.event = event
            cell.updateTableViewCell()
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Deadline Cell", for: indexPath) as! DeadlineTableViewCell
            cell.event = event
            
            cell.completionHandler = { () in
                
                print("Deadline Cell's CH - Message from EPVC")
                
                self.completeButtonPressed()
            }
            
            cell.updateTableViewCell()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Location Cell", for: indexPath) as! LocationTableViewCell
            cell.event = event
            cell.configureTableViewCell()
            return cell
        }
        
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 114
        } else if indexPath.section == 1 {
            return 142
        } else {
            return 250
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Location Manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(#function)")
    }
    
    // MARK: - Completion
    
    // Logic for pressing 'complete' button inside Deadline Cell
    
    func completeButtonPressed() {
        if event.requiresLocation {
            
            let currentLocation = locationManager.location
            // Fatal error: Unexpectedly found nil while unwrapping an Optional value
            let currentPoint = MKMapPoint.init(currentLocation!.coordinate)
            
            let locationCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! LocationTableViewCell
            // In region
            if locationCell.mapView.visibleMapRect.contains(currentPoint) {
                complete()
            }
            // Not in region
            else {
                // Alert
                let alertController = UIAlertController(title: "Check-In Required", message: "You must be within the map region to complete the event", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Okay", style: .default) { (action: UIAlertAction) in
                        print("User chose default action - Not in region - EPVC")
                }
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true)
            }
        } else {
            complete()
        }
    }
    
    func complete() {
        // Update model
        event.completeEvent()
        // Update view
        updateEventPage()
        // Save model
        EventsModel.sharedModel.save()
        // Update corresponding Event Table View Cell
        completionHandler()
    }
    
    func updateEventPage() {
        let streakTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! StreakTableViewCell
        let deadlineTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! DeadlineTableViewCell
        streakTableViewCell.updateTableViewCell()
        deadlineTableViewCell.updateTableViewCell()
    }

}
