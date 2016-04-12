//
//  FuncGlobal.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import MapKit
import CoreData

func appDelegate() -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
}
func context() -> NSManagedObjectContext {
    return appDelegate().coreDataStack.context
}
func zoomToUserLocationInMapView(mapView: MKMapView) {
    if let coordinate = mapView.userLocation.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
        mapView.setRegion(region, animated: true)
    }
}
func zoomToLocationInMapView(mapView: MKMapView, coordinate: CLLocationCoordinate2D) {
    let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
    mapView.setRegion(region, animated: true)
}
