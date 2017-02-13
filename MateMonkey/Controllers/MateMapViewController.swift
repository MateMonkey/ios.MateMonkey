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
            fetcherQueue.async {
                self.fetcher.queryForMapRect(self.mapView.visibleMapRect)
            }
        }
    }
    var currentDealers = [MMDealer]()
    
    // MARK: - Constants
    let fetcher = MMDealerFetcher()
    let fetcherQueue = DispatchQueue(label: "bg_fetcher_queue", qos: .userInitiated)
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetcherQueue.async {
            self.fetcher.queryForMapRect(self.mapView.visibleMapRect)
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
        fetcherQueue.async {
            self.fetcher.queryForMapRect(mapView.visibleMapRect)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let identifier = annotation.subtitle! {
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                let imageName = "MapPin_" + identifier
                view.image = UIImage(named: imageName)
                view.canShowCallout = false
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let dealerId = view.annotation?.title {
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let detailVC: DealerDetailViewController = mainStoryboard.instantiateViewController(withIdentifier: "DealerDetailView") as! DealerDetailViewController
            if let dealer = fetcher.results.filter({ $0.title == dealerId }).first {
                detailVC.dealerToDisplay = dealer
                let navController = UINavigationController(rootViewController: detailVC)
                present(navController, animated: true, completion: nil)
            } else {
                print("The dealer was not found in the fetcher's result.")
            }
        } else {
            print("The dealer seems to not have an ID as the title?!?")
        }
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}

extension MateMapViewController: MMDealerFetcherDelegate {
    func queryCompleted(sender: MMDealerFetcher) {
        
        DispatchQueue.main.async {
            // call a method to populate the map with the fetcher's results
            print("There are \(sender.results.count) dealers on the map.")
            
            if sender.results.isEmpty {
                // TODO: if the results-Array from the fetcher is empty, we should display a message telling the user (popup, "toast", or similar)
                // } else if sender.results.count >= 15 {
                // TODO: if there are too many results, the user might not be able to select a single dealer and it might become very messy
            } else {
                let currentDealers = self.mapView.annotations
                for dealer in sender.results {
                    if currentDealers.contains(where: { $0.title! == String(dealer.id) }) {
                        // should be on the map already
                        print("The dealer \(dealer.id) already exists and will not be added again.")
                    } else {
                        self.mapView.addAnnotation(dealer)
                    }
                }
            }
            // finish up by stopping the spinner
            self.loadingSpinner.stopAnimating()
        }
    }
}
