//
//  LocationsCollectionViewCell.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 11/26/16.
//  Copyright © 2016 AdrienVillez. All rights reserved.
//

import UIKit

class LocationsCollectionViewCell: UICollectionViewCell, FirebaseManagerDelegate
{
    // MARK: - Properties
    @IBOutlet var locationImageView: UIImageView!
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var locationLOSTNameLabel: UILabel!
    
    var firebaseManager: FirebaseManager?
    var locationForDisplay: Locations?
    
    // MARK: - Lifecycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    // MARK: - Functions
    func setLocation(_ location: Locations)
    {
        self.locationForDisplay = location
        
        locationNameLabel.text = locationForDisplay!.title
        locationLOSTNameLabel.text = locationForDisplay!.nameInLOST
        
        // Fetch the image
        if firebaseManager == nil
        {
            firebaseManager = FirebaseManager()
            firebaseManager?.firebaseManagerDelegate = self
        }
        
        firebaseManager?.getImageFromDatabase(imageName: self.locationForDisplay!.image)
        
    }
    
    // MARK: - FirebaseManagerDelegate Methods
    func firebaseManager(imageName: String, imageData: Data)
    {
        // Set the imageView with the image data:
        if imageName == locationForDisplay?.image
        {
            locationImageView.image = UIImage(data: imageData)
        }
    }
}
