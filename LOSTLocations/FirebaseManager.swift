//
//  FirebaseManager.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 4/30/17.
//  Copyright © 2017 AdrienVillez. All rights reserved.
//

import UIKit
import Firebase

@objc protocol FirebaseManagerDelegate
{    
    @objc optional func firebaseManager(locations: [Locations])
    @objc optional func firebaseManager(imageName: String, imageData: Data)
}

class FirebaseManager: NSObject {

    // MARK: - Properties
    var reference: DatabaseReference!
    var firebaseManagerDelegate: FirebaseManagerDelegate?
    
    // MARK: - Initializer
    
    override init() {
        // Initialize the databse reference:
        reference = Database.database().reference()
        
        super.init()
    }
    
    
    // MARK: - Locations Functions:
    
    func getLocationsFromDatabase() {
        
        // Create an array to store all the locations:
        var allLocations = [Locations]()
        
        // Checks the CacheManager before Firebase:
        if let cachedLocationsDictionary = CacheManager.getLocationsFromCache() {
            
            // We have data in the cache, parce them instead.
            // Call function to parse locations dictionay:
            allLocations = parseLocationsFrom(locationsDictionary: cachedLocationsDictionary)
            
            // Now return the location array.
            // Dispatches this code to the main thread
            DispatchQueue.main.async {
                if let actualFirebaseManagerDelegate = self.firebaseManagerDelegate {
                    actualFirebaseManagerDelegate.firebaseManager?(locations: allLocations)
                }
            }
            return
        }
        
        // Retrieve the list of locations from the database:
        reference.child("locations").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let locationsDict = snapshot.value as? NSDictionary
            
            // See if data is actually present
            if let actualLocationsDict = locationsDict {
                // We actually have locations dictionary
                // Before working with the data, let's save to the cache.
                CacheManager.putLocationsIntoCache(data: actualLocationsDict)
                // Call function to parse locations dictionary
                allLocations = self.parseLocationsFrom(locationsDictionary: actualLocationsDict)
                // Now return the locations array
                // Dispatch this code to be done in main thread
                DispatchQueue.main.async {
                    // Notify the delegate
                    if let actualFirebaseManagerDelegate = self.firebaseManagerDelegate {
                        actualFirebaseManagerDelegate.firebaseManager?(locations: allLocations)
                    }
                }
            }
        })
        
        
        
    }
    
    // MARK: - Version Functions
    
    func getVersionFromDataBase()
    {
        // Get the version from the data base:
        reference.child("version").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let versionString = snapshot.value as? Int
            
            if let databaseVersion = versionString
            {
                print("FirebaseManager: Firebase version is retrieved.")
                print("FirebaseManager: Firebase version is v\(databaseVersion)")
                let cachedVersion = CacheManager.getVersionFromCache()
                
                if cachedVersion != nil
                {
                    print("FirebaseManager: Cached version is v\(cachedVersion!)")
                    // Compare the cached and data base version number:
                    if databaseVersion > cachedVersion!
                    {
                        print("FirebaseManager: Newer version of data is available.")
                        // Remove all cached data
                        CacheManager.cleanDataFromCache()
                        CacheManager.saveVersionIntoCache(version: databaseVersion)
                    }
                }
                else
                {
                    // Save the database version number to cache
                    CacheManager.saveVersionIntoCache(version: databaseVersion)
                }
            }
        })
    }
    
    
    // MARK: - Helper Functions
    
    func parseLocationsFrom(locationsDictionary: NSDictionary) -> [Locations]
    {
        // Declare an array to store the parsed out locations
        var allLocations = [Locations]()
        
        // Loop through all of the KVPs of the locationsDictionary.
        for (locationID, locationData) in locationsDictionary
        {
            let locationDataDict = locationData as! NSDictionary
            
            // Create a Locations object for each and add it to an array to be returned.
            let location = Locations()
            
            // --------------------
            // Current workaround for the: 'unable to bridge nsnumber to float'
            let latitudeAsNSNumber: NSNumber = locationDataDict["latitude"] as! NSNumber
            let longitudeAsNSNumber: NSNumber = locationDataDict["longitude"] as! NSNumber
            let latitudeAsFloat: Float = latitudeAsNSNumber.floatValue
            let longitudeAsFloat: Float = longitudeAsNSNumber.floatValue
            // --------------------
            
            location.id = locationID as! String
            location.title = locationDataDict["title"] as! String
            location.nameInLOST = locationDataDict["nameInLOST"] as! String
            location.address = locationDataDict["address"] as! String
            location.locationDescription = locationDataDict["description"] as! String
            location.image = locationDataDict["image"] as! String
            location.imageFrom = locationDataDict["imageFrom"] as! String
            location.latitude = latitudeAsFloat
            location.longitude = longitudeAsFloat
            location.isPublicAccessible = LocationAccessibilityType(rawValue: locationDataDict["isPublicAccessible"] as! Int)!
            
            allLocations += [location]
        }
        
        let allSortedLocations = allLocations.sorted(by: {$0.title < $1.title})
        
        return allSortedLocations
    }
    
    
    
    func getImageFromDatabase(imageName: String)
    {
        // Get the image
        // Check the cache first
        if let imageData = CacheManager.getImageFromCache(imageName: imageName)
        {
            // Notify the delegate on the main thread
            DispatchQueue.main.async
            {
                // Notify the delegate
                if let actualFirebaseManagerDelegate = self.firebaseManagerDelegate
                {
                    actualFirebaseManagerDelegate.firebaseManager?(imageName: imageName, imageData: imageData)
                }
            }
            return
        }
        
        
        // Create the storage and file path references
        let storage = Storage.storage()
        let imagePathReference = storage.reference(withPath: imageName)
        
        // Download in memory with a maximum allowed size of 1Mb (1 * 1024 * 1024 bytes)
        imagePathReference.getData(maxSize: 1 * 1024 * 1024, completion:
            { data, error in
                if error != nil
                {
                    // error
                }
                else if data != nil
                {
                    // Data for the image is returned
                    // Save thge image data into cache
                    CacheManager.putImageIntoCache(data: data!, imageName: imageName)
                    
                    // Notify the delegate on the main thread
                    DispatchQueue.main.async
                    {
                        if let actualFirebaseManagerDelegate = self.firebaseManagerDelegate
                        {
                            actualFirebaseManagerDelegate.firebaseManager?(imageName: imageName, imageData: data!)
                        }
                    }
                }
            })
    }
    
    
    
}
