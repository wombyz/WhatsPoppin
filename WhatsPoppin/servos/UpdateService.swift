//
//  UpdateService.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 2/06/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

class UpdateService {
    static var instance = UpdateService()
    
//        func createEvent(withCoordinate coordinate: CLLocationCoordinate2D) {
//            DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
//                if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                    for user in userSnapshot {
//                        if user.key == Auth.auth().currentUser?.uid {
//                            DataService.instance.REF_USERS.child(user.key).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
//                        }
//                    }
//                }
//            })
//
//        func updateTripsWithCorrdinatesUponRequest() {
//            DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
//                if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                    for user in userSnapshot {
//                        if user.key == Auth.auth().currentUser?.uid {
//                            if !user.hasChild("userIsDriver") {
//                                if let userDict = user.value as? Dictionary<String, AnyObject> {
//                                    let pickupArray = userDict["coordinate"] as! NSArray
//                                    let destinationArray = userDict["tripCoordinate"] as! NSArray
//
//                                    DataService.instance.REF_TRIPS.child(user.key).updateChildValues(["pickupCoordinate": [pickupArray[0], pickupArray[1]], "destinationCoordinate": [destinationArray[0], destinationArray[1]], "passengerKey": user.key, "tripIsAccepted": false])
//                                }
//                            }
//                        }
//                    }
//                }
//            })
//        }
}

