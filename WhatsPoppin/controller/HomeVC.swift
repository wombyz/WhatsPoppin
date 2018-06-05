//
//  HomeVC.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 2/06/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //when the view appears do following checks to show location
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        //check if user has authorised then show their location, otherwise request permission
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // if the user has changed authorise status, then check for and show user loaction on the map
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    func centreMapOnLocation(location: CLLocation) {
        // centre the map on the users coordinate and select view size
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
