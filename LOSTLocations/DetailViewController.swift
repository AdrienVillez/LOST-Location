//
//  DetailViewController.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 6/18/17.
//  Copyright © 2017 AdrienVillez. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, CLLocationManagerDelegate
{
    // MARK: - Properties:
    
    var location: Locations!
    var locationManager: CLLocationManager?
    var selectedLocationLatitude: Float = 0.00
    var selectedLocationLongitude: Float = 0.00
    var selectedLocationURL: String = ""
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    // MARK: @IBOutlets
        
    @IBOutlet weak var titleLabel: UILabel!
    {
        didSet
        {
            titleLabel.text = location?.title
        }
    }
    
    @IBOutlet weak var nameInLOSTLabel: UILabel!
    {
        didSet
        {
            nameInLOSTLabel.text = location?.nameInLOST
        }
    }
    
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    {
        didSet
        {
            locationDescriptionLabel.text = location?.locationDescription
        }
    }
    
    @IBOutlet weak var imageFromLabel: UILabel!
    {
        didSet
        {
            imageFromLabel.text = "Image from \(location!.imageFrom)."
        }
    }
    
    @IBOutlet weak var isPublicAccessibleLabel: UILabel!
    {
        didSet
        {
            isPublicAccessibleLabel.text = location?.getAccessibilityString()
        }
    }
    
    @IBOutlet weak var locationImageView: UIImageView!
    {
        didSet
        {
            locationImageView.image = UIImage(data: CacheManager.getImageFromCache(imageName: location!.image)!)
        }
    }
    
    @IBOutlet weak var addressLabel: UILabel!
        {
        didSet
        {
            addressLabel.text = location?.address
        }
    }
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var isPublicAccessibleContainer: UIView!
    @IBOutlet weak var detailMapView: MKMapView!
    
    // MARK: - App Life Cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the main image:
        locationImageView.contentMode = .scaleAspectFill
        locationImageView.clipsToBounds = true
        
        // Setting up the map:
        detailMapView.showsUserLocation = true
        detailMapView.showsTraffic = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    
        self.isPublicAccessibleContainer.backgroundColor = location?.getAccessibilityColor()
        self.isPublicAccessibleLabel.textColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        checkLocationAuthorizationStatus()
        
        plotPin()
    }

    func openLocationToAppleMaps()
    {
        // URL Scheme to open Apple Maps with the coorect coordinates:
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(selectedLocationLatitude), CLLocationDegrees(selectedLocationLongitude))
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = location.title
        mapItem.openInMaps(launchOptions: nil)
    }
    
    // MARK: - Map Functions

    func plotPin()
    {
        let mkPoint = MKPointAnnotation()
        mkPoint.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(selectedLocationLatitude), longitude: CLLocationDegrees(selectedLocationLongitude))
        
        // Setting up a new coordinate to center the pin a bit down because of the label included in the mapView.
        let latitudeForDisplay: Float = selectedLocationLatitude + 0.001 // Ads 0.001 to the latitude.
        let mkPointForDisplay = MKPointAnnotation()
        mkPointForDisplay.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitudeForDisplay), longitude: CLLocationDegrees(selectedLocationLongitude)) // Pushing the latitude up to have the pin centered lower.
        
        // 500, 500 is zoomed out enough to cover a couple of blocks/streets to help the use to see its location compared to the selected one.
        let region = MKCoordinateRegionMakeWithDistance(mkPointForDisplay.coordinate, 500, 500)  // Sets the zoom level.
        detailMapView.setRegion(region, animated: true) // Displays the zoom level on the mapView
        detailMapView.addAnnotation(mkPoint) // Displays the annotation/pin on the map
        // detailMapView.setCenter(mkPoint.coordinate, animated: true) // Centers the pin on the mapView.
    }
    
    // Authorization
    func checkLocationAuthorizationStatus()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            detailMapView.showsUserLocation = true
        }
        else
        {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    
    // MARK: - @IBActions
    
    @IBAction func exitViewControllerButtonTapped(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addressButtonTapped(_ sender: UIButton)
    {
        print("Address Button Tapped")

        let directionAlert = UIAlertController(title: "Directions", message: "You are about to open Apple Maps to get directions to this LOST Location.", preferredStyle: .alert)
        directionAlert.addAction(UIAlertAction(title: "Get me there!", style: .default) { handler in self.openLocationToAppleMaps() } )
        directionAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(directionAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    
}
