//
//  EventTableViewCell.swift
//  Streaks
//
//  Created by Chris Aguilera on 9/17/18.
//  Copyright © 2018 Chris Aguilera. All rights reserved.
//

import UIKit
import MapKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentStreakLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var event: Event!
    var completionHandler: (() -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        completeButton.setImage(UIImage(named: "check_gray"), for: UIControl.State.disabled)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateTableViewCell() {
        nameLabel.text = event.name
        currentStreakLabel.text = String(event.currentStreak)
        deadlineLabel.text = Event.localTime(forDate: event.deadlineDate)
        if event.isCompleted {
            completeButton.isEnabled = false
            if event.prevDeadlineDate.timeIntervalSinceNow < 0 {
                availableLabel.text = "Now"
            } else {
                availableLabel.text = Event.localTime(forDate: event.prevDeadlineDate)
            }
            
        } else {
            completeButton.isEnabled = true
            availableLabel.text = "Now"
        }
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        
        if event.requiresLocation {
            // Location Manager
            let locationManager = CLLocationManager()
            locationManager.distanceFilter = 1.0
            locationManager.distanceFilter = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            let currentLocation = locationManager.location
            let currentPoint = MKMapPoint.init(currentLocation!.coordinate)
            
            let centerCoordinate = CLLocationCoordinate2DMake(event.latitude, event.longitude)
            let span = MKCoordinateSpan.init(latitudeDelta: event.latitudeDelta, longitudeDelta: event.longitudeDelta)
            let region = MKCoordinateRegion.init(center: centerCoordinate, span: span)
            
            // Make MKMapRect
            let mapRect = MKMapRectForCoordinateRegion(region)
            
            if mapRect.contains(currentPoint) {
                complete()
            } else {
                // TO-DO: Alert
                print("Not in region")
            }
            
            // TO-DO: Should I delete Location Manager?
            
        } else {
            complete()
        }
    }
    
    func complete() {
        
        // Update Model
        event.completeEvent()
        
        // Update View
        updateTableViewCell()
        
        // Save Model
        EventsModel.sharedModel.save()
        
        // Reload Table
        completionHandler()
        
    }
    
    func MKMapRectForCoordinateRegion(_ region: MKCoordinateRegion) -> MKMapRect {
        let a = MKMapPoint(CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta / 2,
                                                                          region.center.longitude - region.span.longitudeDelta / 2))
        let b = MKMapPoint(CLLocationCoordinate2DMake( region.center.latitude - region.span.latitudeDelta / 2,
                                                                           region.center.longitude + region.span.longitudeDelta / 2))
        return MKMapRect(x: min(a.x,b.x), y: min(a.y,b.y), width: abs(a.x-b.x), height: abs(a.y-b.y))
    }

}
