//
//  MapViewController.swift
//  AirQ
//
//  Created by aeronaut on 01.02.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var zoomButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    let decoder = DecoderUtils()
    let colorPicker = AirQualityColor()
    let locationManager = CLLocationManager()
    
    var stationsList = [StationModel]()
    var location: CLLocation?
    
    @IBAction func zoomToCurrentLocation(_ sender: UIButton) {
        var region = MKCoordinateRegion()
        region.span = MKCoordinateSpanMake(0.7, 0.7)
        if let center = location?.coordinate  {
            region.center = center
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        spinner.activityIndicatorViewStyle = .gray
        self.spinner.startAnimating()
        
        decoder.getStationsList(completion: { [unowned self]
            stations in
            self.stationsList = stations!
            for station in self.stationsList {
                if let latitude = station.gegrLat {
                    if let longtitude = station.gegrLon {
                        let annotation = AirQualityPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longtitude)!)
                        annotation.title = station.stationName
                        self.decoder.getStationAirQualityData(stationId: station.stationId!, completion: { [unowned self]
                            data in
                            if let data = data {
                                annotation.color = self.colorPicker.calculateColorFor(parameter: AirParameters.airQuality ,with: data)
                                annotation.stationId = station.stationId
                                annotation.station = station
                            }
                            self.mapView.addAnnotation(annotation)
                            if station.stationId == stations?.last?.stationId {
                                self.spinner.stopAnimating()
                                self.spinner.hidesWhenStopped = true
                            }
                        })
                    }
                }
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.isHidden = true

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?     {
        let identifier = "station"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? AirQualityAnnotationView
        if annotationView == nil {
            annotationView = AirQualityAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        if let annotation = annotation as? AirQualityPointAnnotation {
            mapView.reloadInputViews()
            if annotation.color == colorPicker.noData {
                annotationView?.isHidden = true
            }
            annotationView?.markerTintColor = annotation.color
            annotationView?.glyphText = ""
            annotationView?.animatesWhenAdded = true
//            annotationView?.canShowCallout = true
//            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoDark)
            annotationView?.stationId = annotation.stationId
            annotationView?.station = annotation.station
        }
        return annotationView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            performSegue(withIdentifier: "showStationDetailsFromMap", sender: view)
//        }
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
                    performSegue(withIdentifier: "showStationDetailsFromMap", sender: view)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? AirQualityViewController {
            destinationController.station = (sender as! AirQualityAnnotationView).station
            destinationController.stationId = (sender as! AirQualityAnnotationView).stationId
        }
    }
    
}

class AirQualityPointAnnotation: MKPointAnnotation {
    var color: UIColor?
    var stationId: Int?
    var station: StationModel?
}

class AirQualityAnnotationView: MKMarkerAnnotationView {
    var stationId: Int?
    var station: StationModel?
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let defaultLocation = CLLocation(latitude: 52.2296834, longitude: 21.012318800000003)
        let regionRadius: CLLocationDistance = 1000000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((defaultLocation.coordinate), regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
        location = defaultLocation
    }
    
}




