//
//  LocationTableViewCell.swift
//  Streaks
//
//  Created by Chris Aguilera on 9/19/18.
//  Copyright © 2018 Chris Aguilera. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var event: Event?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Visual Elements
        self.layer.cornerRadius = 5
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureTableViewCell() {
        
        mapView.isHidden = false
        
        // Make coordinate region and set map view
        let centerCoordinate = CLLocationCoordinate2DMake(event!.latitude, event!.longitude)
        let span = MKCoordinateSpan.init(latitudeDelta: event!.latitudeDelta, longitudeDelta: event!.longitudeDelta)
        let region = MKCoordinateRegion.init(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: false)
    }

}
