//
//  ViewController.swift
//  AulaMapKit
//
//  Created by Rayane Xavier on 06/04/20.
//  Copyright © 2020 Rayane Xavier. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    let regionInMaters: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let regian = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMaters, longitudinalMeters: regionInMaters)
            map.setRegion(regian, animated: true)
        }
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them who to turn on permissions
            break
        case .notDetermined:
            // Request authorization
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMaters, longitudinalMeters: regionInMaters)
        map.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
