//
//  CacheManager.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 4/30/17.
//  Copyright © 2017 AdrienVillez. All rights reserved.
//

import UIKit

class CacheManager: NSObject
{
    // MARK: - Locations Functions
    
    static func getLocationsFromCache() -> NSDictionary?
    {
        // Checks UserDefaults for locations:
        let defaults = UserDefaults.standard
        let data = defaults.value(forKey: "Locations") as? NSDictionary
        print("CacheManager: Locations are now returned from the cache.")
        return data
    }
    
    static func putLocationsIntoCache(data: NSDictionary)
    {
        // Saves the data into UserDefaults:
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: "Locations")
        print("CacheManager: Locations are now saved into the cache.")
        defaults.synchronize()
    }
    
    // MARK: - Version Functions
    
    static func getVersionFromCache() -> Int?
    {
        let defaults = UserDefaults.standard
        let versionNumber = defaults.integer(forKey: "Version")
        print("CacheManager: Version is now returned from cache.")
        return versionNumber
    }
    
    static func saveVersionIntoCache(version: Int)
    {
        let defaults = UserDefaults.standard
        defaults.set(version, forKey: "Version")
        print("CacheManager: Version is now saved into the cache.")
        defaults.synchronize()
    }
    
    
    // MARK: Cache Functions
    
    static func cleanDataFromCache()
    {
        let defaults = UserDefaults.standard
        let defaultsDictionary = defaults.dictionaryRepresentation()
        
        for (cacheKey, _) in defaultsDictionary
        {
            defaults.removeObject(forKey: cacheKey)
            print("CacheManager: Cache has now been cleaned.")
        }
        
        defaults.synchronize()
    }
    
    // MARK: - Image Functions
    static func getImageFromCache(imageName: String) -> Data?
    {
        // Checks UserDefaults for image data:
        let defaults = UserDefaults.standard
        let imageData = defaults.data(forKey: imageName)
        print("CacheManager: Images are now retrieved from the cache.")
        return imageData
    }
    
    static func putImageIntoCache(data: Data, imageName: String)
    {
        // Saves the data into UserDefaults:
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: imageName)
        print("CacheManager: Images are now saved into the cache.")
        defaults.synchronize()
    }
    
    
    
    
    
    
    
    
    
}
