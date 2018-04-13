//
//  Location.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 11/26/16.
//  Copyright © 2016 AdrienVillez. All rights reserved.
//

import UIKit

enum LocationAccessibilityType: Int
{
    case Yes
    case YesPaid
    case No
}


class Locations: NSObject
{
    var id: String = ""
    var title: String = ""
    var nameInLOST: String = ""
    var address: String = ""
    var latitude: Float = 0
    var longitude: Float = 0
    var locationDescription: String = ""
    var image: String = ""
    var imageFrom: String = ""
    var imageFromURL: String = ""
    var isPublicAccessible = LocationAccessibilityType.No


    func getAccessibilityString() -> String
    {
        switch isPublicAccessible.rawValue
        {
            case 0: return "This location is accessible to the public."
            case 1: return "This location is available with paid access."
            default: return "This location is not accessible to the public."
        }
    }

    func getAccessibilityColor() -> UIColor
    {
        switch isPublicAccessible.rawValue
        {
            case 0: return UIColor(red: 24/255, green: 94/255, blue: 101/255, alpha: 1) // Green
            case 1: return UIColor(red: 241/255, green: 92/255, blue: 37/255, alpha: 1) // Orange
            default: return UIColor(red: 158/255, green: 22/255, blue: 23/255, alpha: 1) // Red
        }
    }

}




