//
//  MapViewController.swift
//  Timely
//
//  Created by 张泽正 on 2019/5/5.
//  Copyright © 2019 monash. All rights reserved.
//
// Set users' location to centre: https://www.youtube.com/watch?v=WPpaAy73nJc
// Search the address: https://www.youtube.com/watch?v=GYzNsVFyDrU

import UIKit
import MapKit
import CoreLocation

class TaskMapViewController: UIViewController {
    
    var taskAddress = "None"

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = taskAddress
        checkLocationService()
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centreViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func centreViewOnAddress(){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = taskAddress
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start{ (response, error) in
            if response == nil{
                print("Error")
            }
            else{
                // Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                // Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.taskAddress
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                // Zooming
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: self.regionInMeters, longitudinalMeters: self.regionInMeters)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled(){
            // Setup the Location manager.
            setupLocationManager()
            checkLocationAuthorization()
        }
        else{
            //Show alert and let user open this.
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centreViewOnAddress()
            //centreViewOnUserLocation()
            //locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TaskMapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let centre = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: centre, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
