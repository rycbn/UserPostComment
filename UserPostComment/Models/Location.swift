//
//  Location.swift
//  UserPostComment
//
//  Created by Roger Yong on 08/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import MapKit

class Location: NSObject, MKAnnotation {
    var city: String?
    var coordinate: CLLocationCoordinate2D

    init(city: String, coordinate: CLLocationCoordinate2D) {
        self.city = city
        self.coordinate = coordinate
    }
}
