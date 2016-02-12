//
//  MapsViewController.swift
//  Conferencia
//
//  Created by Alexis Chan on 05/02/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

class MapsViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let initialLocation = CLLocation(latitude:44.8058523, longitude:-0.6066426)
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
  //  let locationManager = CLLocationManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        mapView.showsUserLocation = true
        
        //location manager update
//            self.locationManager.requestWhenInUseAuthorization()
//            if CLLocationManager.locationServicesEnabled() {
//                self.locationManager.delegate = self
//                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//                self.locationManager.startUpdatingLocation()
//        }
        //map update
        centerMapOnLocation(initialLocation)
    }

    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("Failed to find user's location: \(error.localizedDescription)")
//    }

}