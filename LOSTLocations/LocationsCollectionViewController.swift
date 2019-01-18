//
//  LocationsCollectionViewController.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 11/26/16.
//  Copyright © 2016 AdrienVillez. All rights reserved.
//

import UIKit
import Crashlytics

private let collectionCell = "CollectionCell"
private let toDetailSegue = "toDetailSegue"
private let detailScreenIdentifier = "DetailScreen"
private let settingsScreenIdentifier = "SettingsScreen"

class LocationsCollectionViewController: UICollectionViewController, LocationsModelDelegate, UICollectionViewDelegateFlowLayout
{
    // MARK: - Properties
    let locationsModel = LocationsModel()
    let screenSize: CGSize = UIScreen.main.bounds.size
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    var locations = [Locations]()
    
    @IBOutlet weak var cellShadingView: UIView!
    @IBOutlet weak var settingBarButtonItem: UIBarButtonItem!
    
    // MARK: - App Life Cycle:
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        locationsModel.delegate = self
        
        // Will get locations, or from the cache or from the database.
        locationsModel.getLocations()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // Will update the database if the cache is outdated.
        locationsModel.checkDataVersion()
    }
    
    // MARK: - LocationsModel Delegate
    
    func locationsModel(locations: [Locations])
    {
        // Sets the returned locations to the locations property:
        self.locations = locations
        
        // Reloads the collection view:
        collectionView?.reloadData()
    }
    
    func locationsModel(imageName: String, imageData: Data)
    {
        // Detail model has returned with the image data, now we can set the imageView
        // Wait?  why is this method empty!?
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return sectionInsets.left
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return locations.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let collCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCell, for: indexPath) as! LocationsCollectionViewCell
        
        let location = locations[indexPath.row]
        
        collCell.setLocation(location)
        
        return collCell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // get the cell and check that it isn't nil.
        let cell = collectionView.cellForItem(at: indexPath) as? LocationsCollectionViewCell
        guard let _ = cell else
        {
            return
        }
        
        // Create an instance of detailViewController and check that it isn't nil.
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: detailScreenIdentifier) as? DetailViewController
        guard let _ = detailViewController else
        {
            return
        }
        
        detailViewController!.location = locations[indexPath.row]
        detailViewController!.selectedLocationLatitude = locations[indexPath.row].latitude
        detailViewController!.selectedLocationLongitude = locations[indexPath.row].longitude
        detailViewController!.selectedLocationURL = locations[indexPath.row].imageFromURL

        // Sets the presentation mode:
        detailViewController!.modalTransitionStyle = .coverVertical
        detailViewController!.modalPresentationStyle = .fullScreen
        present(detailViewController!, animated: true, completion: nil)
    }

    
    // MARK: - @IBActions
    
    @IBAction func settingsBarItemPressed (_: UIBarButtonItem)
    {
        let settingsViewController = storyboard?.instantiateViewController(withIdentifier: settingsScreenIdentifier) as? SettingsViewController
        guard let _ = settingsViewController else
        {
            return
        }
        
        // Sets the presentation mode:
        settingsViewController!.modalTransitionStyle = .coverVertical
        settingsViewController!.modalPresentationStyle = .fullScreen
        present(settingsViewController!, animated: true, completion: nil)
    }
}
