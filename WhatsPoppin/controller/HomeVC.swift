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
import FacebookCore
import FacebookLogin

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class HomeVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var regionRadius: CLLocationDistance = 1000
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        centerMapOnUserLocation()
//        let locationSearchTable = LocationSearchTable()
//        locationSearchTable.handleMapSearchDelegate = self
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
    
    func centerMapOnUserLocation() {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centreMapOnLocation(location: CLLocation) {
        // centre the map on the users coordinate and select view size
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createSegue" {
            
            if let navController = segue.destination as? UINavigationController {
                
                if let childVC = navController.topViewController as? CreateEventVC {
                    //TODO: access here chid VC  like childVC.yourTableViewArray = localArrayValue
                    childVC.passedMapView = mapView
                    print("passed")
                }
            }
        }
    }
    
//    func loadDriverAnnotationsFromFB() {
//        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let driverSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                for driver in driverSnapshot {
//                    if driver.hasChild("userIsDriver") {
//                        if driver.hasChild("coordinate") {
//                            if driver.childSnapshot(forPath: "isPickupModeEnabled").value as? Bool == true {
//                                if let driverDict = driver.value as? Dictionary<String, AnyObject> {
//                                    //pull out value of key coordinate
//                                    let coordinateArray = driverDict["coordinate"] as! NSArray
//                                    let driverCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
//
//                                    let annotation = DriverAnnotation(coordinate: driverCoordinate, withKey:  driver.key)
//                                    self.mapView.addAnnotation(annotation)
//
//                                    var driverIsVisible: Bool {
//                                        return self.mapView.annotations.contains(where: { (annotation) -> Bool in
//                                            if let driverAnnotation = annotation as? DriverAnnotation {
//                                                if driverAnnotation.key == driver.key {
//                                                    driverAnnotation.update(annotationPosition: driverAnnotation, withCoordinate: driverCoordinate)
//                                                    return true
//                                                }
//                                            }
//                                            return false
//                                        })
//                                    }
//
//                                    if !driverIsVisible {
//                                        self.mapView.addAnnotation(annotation)
//                                    }
//                                }
//                            } else {
//                                for annotation in self.mapView.annotations {
//                                    if annotation.isKind(of: DriverAnnotation.self) {
//                                        if let annotation = annotation as? DriverAnnotation {
//                                            if annotation.key == driver.key {
//                                                self.mapView.removeAnnotation(annotation)
//                                            }
//                                        }
//                                    }
//
//                                }
//                            }
//                        }
//
//                    }
//                }
//            }
//        })
//    }
}

extension HomeVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

extension HomeVC: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}
