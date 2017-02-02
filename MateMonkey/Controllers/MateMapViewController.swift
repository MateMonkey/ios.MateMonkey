//
//  ViewController.swift
//  MateMonkey
//
//  Created by Peter on 29.01.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit
import MapKit

class MateMapViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    // MARK: - Variables
    var locationManager: CLLocationManager!
    var initialLocationSet = false {
        didSet {
            // if it is now true, lets request surrounding dealers!
            loadingSpinner.startAnimating()
            fetcher.queryForMapRect(self.mapView.visibleMapRect)
        }
    }
    
    // MARK: - Constants
    let fetcher = MMDealerFetcher()
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetcher.delegate = self
        mapView.delegate = self
        
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.stopAnimating()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func centerUserLocation(_ sender: UIButton) {
        if let currentLocation = locationManager.location {
            centerMapOnLocation(currentLocation, animated: true)
        }
    }
    
    // MARK: - Functions
    func centerMapOnLocation(_ location: CLLocation, animated: Bool) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: animated)
    }
    
}

// MARK: - Extensions
extension MateMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if initialLocationSet == false {
            if let lastLocation = locations.last {
                centerMapOnLocation(lastLocation, animated: false)
                initialLocationSet = true
            }
        }
    }
}

extension MateMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        loadingSpinner.startAnimating()
        fetcher.queryForMapRect(mapView.visibleMapRect)
    }
}

extension MateMapViewController: MMDealerFetcherDelegate {
    func queryCompleted(sender: MMDealerFetcher) {
        // call a method to populate the map with the fetcher's results
        print("There are \(sender.results.count) dealers on the map.")
        // TODO: if the results-Array from the fetcher is empty, we should display a message telling the user (popup, "toast", or similar)
        
        // finish up by stopping the spinner
        DispatchQueue.main.async {
            self.loadingSpinner.stopAnimating()
        }
    }
}
