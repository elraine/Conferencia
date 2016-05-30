

import UIKit
import MapKit
import CoreLocation


class MapsViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    
    @IBOutlet weak var displayCoords: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var back: UIBarButtonItem!
    
    let initialLocation = CLLocation(latitude:44.8058523, longitude:-0.6066426)
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
           }
    //user location
  let locationManager = CLLocationManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //location manager update
          self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.requestLocation()
        }
        
        
        //map update
        mapView.delegate = self
        mapView.showsUserLocation = true
        let selfLoc = locationManager.location
        if((selfLoc) != nil){
            centerMapOnLocation(locationManager.location!)
        }else{
            centerMapOnLocation(initialLocation)
        }
        
    }

    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("location = \(locValue.latitude) \(locValue.longitude)")
        
        displayCoords.text = "latitude : \(locValue.latitude)" + "\n long : \(locValue.longitude)"
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }


    
    
}