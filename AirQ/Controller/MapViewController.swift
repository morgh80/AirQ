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
    let decoder = DecoderUtils()
    let colorPicker = AirQualityColor()
    var stationsList = [StationModel]()
    let locationManager = CLLocationManager()
    var location: CLLocation?
    @IBOutlet weak var zoomButton: UIButton!
    
    @IBAction func zoomToCurrentLocation(_ sender: UIButton) {
        var region = MKCoordinateRegion()
        region.span = MKCoordinateSpanMake(0.7, 0.7)
                if let center = location?.coordinate  {
                    region.center = center
                    mapView.setRegion(region, animated: true)
                    print(center)
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        decoder.getStationsListWithDecoder(completion: {
            stations in
            self.stationsList = stations!
            for station in self.stationsList {
                if let latitude = station.gegrLat {
                    if let longtitude = station.gegrLon {
                        let annotation = AirQualityPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longtitude)!)
                        self.decoder.getStationAirQualityData(stationId: station.stationId!, completion: {
                            data in
                            if let data = data {
                                annotation.color = self.colorPicker.calculateColorFor(parameter: AirParameters.airQuality ,with: data)
                            }
                            self.mapView.addAnnotation(annotation)
                        })
                    }
                }
            }
            print(3)
        })
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?     {
        let identifier = "station"
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        if let annotation = annotation as? AirQualityPointAnnotation {
            mapView.reloadInputViews()
            if annotation.color == colorPicker.noData {
                annotationView?.isHidden = true
            }
            annotationView?.markerTintColor = annotation.color
            annotationView?.glyphText = annotation.title
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class  AirQualityPointAnnotation: MKPointAnnotation {
    var color: UIColor?
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print (1)
        self.location = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print(2)
        let defaultLocation = CLLocation(latitude: 42.2296834, longitude: 21.012318800000003)
        let regionRadius: CLLocationDistance = 1000000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((defaultLocation.coordinate), regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
        location = defaultLocation
    }
    
}




