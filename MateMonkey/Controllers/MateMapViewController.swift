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
    var initialLocationSet = false
    var currentDealers = [MMDealer]()
    
    var filterView = MMFilterView(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.height - GlobalValues.FVExpanderHeight, width: UIScreen.main.bounds.width, height: GlobalValues.FilterViewHeight))
    var filterExpanded = false
    
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
        
        filterView.delegate = self
        self.view.addSubview(filterView)
        
        getProductDict()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    func showBanner(withMessage message: String) {
        let banner = Banner(title: message, subtitle: VisibleStrings.bannerTapToDismiss, backgroundColor: UIColor.monkeyGreenDark())
        banner.dismissesOnTap = true
        banner.show(duration: 5.0)
    }
    
    func getProductDict() {
        let urlString = GlobalValues.baseURL + "products"
        
        let requestURL: URL = URL(string: urlString)!
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {data, response , error in
            
            var statusCode = Int()
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
            
            if (statusCode == 200) {
                print(data!)
                
                if let productDict = try? MMJSONParser(data: data!).parseProductList() {
                    print(productDict)
                    GlobalValues.productDict = productDict
                } else {
                    print("The parser had a problem parsing the products.")
                }
            } else {
                print(error.debugDescription)
            }
        }
        task.resume()
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
                let image = UIImage(named: imageName)!
                view.image = image
                view.canShowCallout = false
                view.centerOffset = CGPoint(x: 0, y: -image.size.height/2)
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
            #if DEBUG
            print("There are \(sender.results.count) dealers in the map area.")
            #endif
            
            let filteredDealers = MMDealerFilter().filterDealers(sender.results)

            if filteredDealers.isEmpty {
                // if the results-Array from the fetcher is empty, we should display a message telling the user (popup, "toast", or similar)
                self.showBanner(withMessage: VisibleStrings.bannerMessageNoDealers)
            } else if filteredDealers.count >= GlobalValues.maximumPinsVisible {
                // if there are too many results, the user might not be able to select a single dealer and it might become very messy
                self.showBanner(withMessage: VisibleStrings.bannerMessageTooManyDealers)
            } else {
                print("There are \(filteredDealers.count) dealers in the map area after filtering.")
                for dealer in filteredDealers {
                    self.mapView.addAnnotation(dealer)
                }
            }
            // finish up by stopping the spinner
            self.loadingSpinner.stopAnimating()
        }
    }
}

extension MateMapViewController: MMFilterViewDelegate {
    func expandFilter(sender: MMFilterView) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            
            if self.filterExpanded == false {
                self.filterView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.height - 229, width: UIScreen.main.bounds.width, height: 244)
            } else {
                self.filterView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.height - 40, width: UIScreen.main.bounds.width, height: 244)
            }
        }) { (completed) in
            self.filterExpanded = !self.filterExpanded
        }
    }
    
    func presentFromFilterView(viewController: UIViewController) {
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true, completion: nil)
    }
    
    func filtersHaveChanged() {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        loadingSpinner.startAnimating()
        fetcherQueue.async {
            self.fetcher.queryForMapRect(self.mapView.visibleMapRect)
        }
    }
}
