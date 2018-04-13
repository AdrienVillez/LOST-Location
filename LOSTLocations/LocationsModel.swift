//
//  LocationsModel.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 6/17/17.
//  Copyright © 2017 AdrienVillez. All rights reserved.
//

import UIKit


protocol LocationsModelDelegate
{
    func locationsModel(locations: [Locations])
    func locationsModel(imageName: String, imageData: Data)
}



class LocationsModel: NSObject, FirebaseManagerDelegate
{
    // Properties
    var delegate: LocationsModelDelegate?
    var firebaseManager: FirebaseManager?
    
    func getLocations()
    {
        // Get locations from FirebaseManager
        if firebaseManager == nil
        {
            firebaseManager = FirebaseManager()
            firebaseManager!.firebaseManagerDelegate = self
        }
        
        // Tells FirebaseManager to fetch the locations:
        firebaseManager!.getLocationsFromDatabase()
    }
    
    func getImage(imageName: String)
    {
        firebaseManager?.getImageFromDatabase(imageName: imageName)
    }
    
    func checkDataVersion()
    {
        if firebaseManager == nil
        {
            firebaseManager = FirebaseManager()
            firebaseManager!.firebaseManagerDelegate = self
        }
        
        firebaseManager!.getVersionFromDataBase()
    }
    
    
    
    // MARK: - FirebaseManager Delegate Methods
    func firebaseManager(locations: [Locations])
    {
        // Notifies the delegate
        if let actualDelegate = delegate
        {
            actualDelegate.locationsModel(locations: locations)
        }
    }
    
    func firebaseManager(imageName: String, imageData: Data)
    {
        if let actualDelegate = delegate
        {
            actualDelegate.locationsModel(imageName: imageName, imageData: imageData)
        }
    }
}
