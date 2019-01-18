//
//  MapViewController.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 11/26/16.
//  Copyright © 2016 AdrienVillez. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, LocationsModelDelegate, MKMapViewDelegate
{

    // MARK: - Properties
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var userCurrentLocationButton: UIButton!
    @IBOutlet weak var refocusOnAreaButton: UIButton!
    @IBOutlet weak var mapSegmentedControl: UISegmentedControl!
    
    var locations: [Locations]!
    var locationManager = CLLocationManager()
    var model: LocationsModel?

    let regionRadius: CLLocationDistance = 42000 // Region radius to set up the zoom around Honolulu.
    let initialLocation = CLLocation(latitude: 21.4861, longitude: -157.9468) // Hawaii Coordinates
    
    // MARK: - View life cicle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Sets the initial location and zoom of the mapView:
        centerMapOnLocation(mapLocation: initialLocation)
        
        // Rounds the corners of the 2 buttons on the map:
        userCurrentLocationButton.layer.cornerRadius = 5
        refocusOnAreaButton.layer.cornerRadius = 5
        
        // MKMapViewDelegate
        mapView.delegate = self
        
        // CLLocationManagerDelegate
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // LocationsModel
        if model == nil
        {
            model = LocationsModel()
            model?.delegate = self
        }
        
        model?.getLocations()
        
        // Displays the scale and the compass:
        mapView.showsCompass = true
        mapView.showsScale = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        checkLocationAuthorizationStatus()
        
    }
    
    
    // MARK: - MapKit Set Up

    // Map focus area (O'ahu)
    func centerMapOnLocation(mapLocation: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: mapLocation.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Focuses on the user's location:
    func focusOnUserCurrentLocation()
    {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse
        {
            let errorAlert = UIAlertController(title: nil, message: "This Feature Requires Access To Your Location, Please Check Your Privacy Settings.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            errorAlert.addAction(cancelAction)
            present(errorAlert, animated: true, completion: nil)
        
            return
        }
        
        let userLatitude = locationManager.location?.coordinate.latitude
        let userLongitude = locationManager.location?.coordinate.longitude
        let userCurrentLocation = CLLocation(latitude: userLatitude!, longitude: userLongitude!)
        
        UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            let userRegion = MKCoordinateRegion(center: userCurrentLocation.coordinate, latitudinalMeters: 700, longitudinalMeters: 700)  // Sets the zoom level.
            self.mapView.setRegion(userRegion, animated: true)
            
            // self.centerMapOnLocation(mapLocation: userCurrentLocation)
            
        }, completion: nil)
    }
    
    // Authorization
    func checkLocationAuthorizationStatus()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            mapView.showsUserLocation = true
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // MARK: Map Pins
    
    func plotPins()
    {
        var pinsArray = [MKPointAnnotation]()
        
        // Go through the array of locations and plot a pin for them.
        for loc in locations
        {
            // Create a pin
            let pin = MKPointAnnotation()
            
            // Set its properties
            pin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(loc.latitude), longitude: CLLocationDegrees(loc.longitude))
            pin.title = loc.title
            pin.subtitle = loc.nameInLOST
            
            // Add it to the MapView
            mapView.addAnnotation(pin)
            
            // Append the pin in the pinsArray
            pinsArray.append(pin)
        }
        
        // Show Annotation
        mapView.showAnnotations(pinsArray, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let identifier = "LocationPin"
        
        if annotation.isKind(of: MKUserLocation.self)
        {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil
        {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        // TODO: Needs confirmation this is working! (or make it work!)
//        for loc in locations
//        {
//            let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
//            leftIconView.image = UIImage(named: loc.image)
//            annotationView?.leftCalloutAccessoryView = leftIconView
//        }
        
        return annotationView
    }
    
    // MARK: - LocationsModelDelegate
    
    func locationsModel(locations: [Locations])
    {
        self.locations = locations
        
        plotPins()
    }
    
    func locationsModel(imageName: String, imageData: Data)
    {
        // Detail model has returned with the image data, now we can set the imageView
    }
    
    // MARK: - IBActions:
    
    @IBAction func refocusInAreaButtonTapped(_ sender: UIButton)
    {
        UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.centerMapOnLocation(mapLocation: self.initialLocation)
        }, completion: nil)
        
        
    }
    
    
    @IBAction func userCurrentLocationButtonTapped(_ sender: UIButton)
    {
        self.focusOnUserCurrentLocation()
    }
    
    @IBAction func mapSegmentedControlSelected(_ sender: UISegmentedControl)
    {
        switch(sender.selectedSegmentIndex)
        {
            case 0: mapView.mapType = .standard
            case 1: mapView.mapType = .satellite
            default: mapView.mapType = .hybrid
        }
    }

}
