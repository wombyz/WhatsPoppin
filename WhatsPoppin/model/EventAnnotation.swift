//
//  EventAnnotation.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 14/06/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import Foundation
import MapKit

class EventAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    var title: String?
    var subtitle: String?
    var uuid: UUID?
    
    init(coordinate: CLLocationCoordinate2D, withKey key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }    
}
