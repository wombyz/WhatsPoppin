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

    func updateUserData(email: String, fname: String, lname: String, link: String, pictureURL: String, name: String, FBid: String) {
        let userData = ["email": email, "firstname": fname, "lastname": lname, "pictureURL": pictureURL, "name": name, "link": link] as [String: Any]
        DataService.instance.REF_USERS.child(FBid).updateChildValues(userData)
        print(userData)
    }
    
}

