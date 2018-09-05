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
import Firebase

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var regionRadius: CLLocationDistance = 1000
    var selectedPin:MKPlacemark? = nil
    var radius: CLLocationDistance = 1000
    var cir: MKCircle!
    var selectedAnnotation: MKAnnotation?
    var selectedAnnotationKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        centerMapOnUserLocation()
        
        DataService.instance.REF_EVENTS.observe(.value, with: { (snapshot) in
            self.loadAnnotationsFromFB()
        })
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
        if segue.identifier == "swag" {
            if let childVC = segue.destination as? ViewEventVC {
                childVC.annotationKey = selectedAnnotationKey
            }
        }
    }
    
    func loadAnnotationsFromFB() {
        DataService.instance.REF_EVENTS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let eventSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for event in eventSnapshot {
                        if event.hasChild("coordinate") {
                            print("found child")
                            if event.childSnapshot(forPath: "eventIsPublic").value as? Bool == true {
                                if let eventDict = event.value as? Dictionary<String, AnyObject> {
                                    print("eventDict Found")
                                    //pull out value of key coordinate
                                    let coordinateArray = eventDict["coordinate"] as! NSArray
                                    let eventCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                                    print(eventCoordinate)
                                    let annotation = EventAnnotation(coordinate: eventCoordinate,  withKey:  event.key)
                                    self.cir = MKCircle(center: eventCoordinate, radius: self.radius)
                                    self.mapView.add(self.cir)
                                    self.mapView.addAnnotation(annotation)
                                    print("added to map in load func")
                                }
                            } else {
                                for annotation in self.mapView.annotations {
                                    if annotation.isKind(of: EventAnnotation.self) {
                                        if let annotation = annotation as? EventAnnotation {
                                            if annotation.key == event.key {
                                                self.mapView.removeAnnotation(annotation)
                                        }
                                    }
                                }

                            }
                        }
                    }
                }
            }
        })
    }
    
    func searchForEvent(latitude: CLLocationDegrees, longitude: CLLocationDegrees , completion:@escaping(_ str:String?) -> Void ) {
        var eventCoordinate: CLLocationCoordinate2D?
        var eventKey: String?
        var selectedEventKey = ""
        DataService.instance.REF_EVENTS.observeSingleEvent(of: .value, with: { (snapshot) in
            print("1")
            if let eventSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for event in eventSnapshot {
                    eventKey = event.key
                    print("\(eventKey)")
                    print("2")
                    if event.childSnapshot(forPath: "coordinate").value != nil  {
                        if let eventDict = event.value as? Dictionary<String, AnyObject> {
                            print("3")
                            //pull out value of key coordinate
                            let coordinateArray = eventDict["coordinate"] as! NSArray
                            print(coordinateArray)
                            eventCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                            print(eventCoordinate)
                            if (eventCoordinate?.latitude, eventCoordinate?.longitude) == (latitude, longitude) {
                                selectedEventKey = eventKey!
                                print("\(selectedEventKey), correct event")
                                completion(selectedEventKey)
                            } else {
                                print("incorrect event")
                                completion(nil)
                            }
                        }
                    }
                }
            }
        })
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected")
        var selected = ""
        self.selectedAnnotation = view.annotation
        let lat = selectedAnnotation?.coordinate.latitude
        let lon = selectedAnnotation?.coordinate.longitude
        
//        searchForEvent(latitude: lat!, longitude: lon!) { (str) in
//            selected = str!
//        }
//        selectedAnnotationKey = selected
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "event"
        if let annotation = annotation as? EventAnnotation {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            annotation.title = "Event"
            annotation.subtitle = "18th May"
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.rightCalloutAccessoryView = UIButton(type: .infoLight)
            view?.canShowCallout = true
            
            let pinImage = UIImage(named: "hat")
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            view?.image = resizedImage

            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        let overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        overlayRenderer.lineWidth = 1.0
        overlayRenderer.fillColor = UIColor.init(red: 35/255, green: 127/255, blue: 255/255, alpha: 0.4)
        return overlayRenderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "swag", sender: self)
        }
    }
    
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

extension HomeVC: MKMapViewDelegate {
}

