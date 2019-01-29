//
//  AddEventViewController.swift
//  Streaks
//
//  Created by Chris Aguilera on 9/18/18.
//  Copyright © 2018 Chris Aguilera. All rights reserved.
//

import UIKit
import MapKit

class AddEventViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var frequencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    
    var completionHandler: (() -> Void)!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.becomeFirstResponder()
        
        nameTextField.delegate = self
        
        // Visual Elements
        saveButton.layer.cornerRadius =  5
        
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
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let name = nameTextField.text!
        nameTextField.resignFirstResponder()
        
        let frequency: EventFrequency
        if frequencySegmentedControl.selectedSegmentIndex == 0 {
            frequency = .daily
        } else if frequencySegmentedControl.selectedSegmentIndex == 1 {
            frequency = .weekly
        } else {
            frequency = .monthly
        }
        
        let locationRequired: Bool
        if locationSwitch.isOn {
            locationRequired = true
        } else {
            locationRequired = false
        }
        
        let event = Event(withName: name, withFrequency: frequency, requiresLocation: locationRequired)
        
        // Coordinate region
        if locationRequired {
            let coordinateRegion = MKCoordinateRegion.init(mapView.visibleMapRect)
            event.latitude = coordinateRegion.center.latitude
            event.longitude = coordinateRegion.center.longitude
            event.latitudeDelta = coordinateRegion.span.latitudeDelta
            event.longitudeDelta = coordinateRegion.span.longitudeDelta
        }
        
        EventsModel.sharedModel.addEvent(event)
        completionHandler()
    }
    
    @IBAction func locationSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            mapView.isHidden = false
        } else {
            mapView.isHidden = true
        }
    }
    
    // MARK: - Location Manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = manager.location
        
        let region = MKCoordinateRegion.init(center: currentLocation!.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func didPressedBackground(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
