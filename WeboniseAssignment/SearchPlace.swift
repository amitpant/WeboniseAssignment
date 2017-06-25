//
//  SearchPlace.swift
//  googleapisdemo
//
//  Created by Amit Pant on 24/06/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Place:NSObject {
    //Mark: - Properties
    var name:String
    var placeid:String
    var type:String
    var location:CLLocation
    
    init( name: String, placeid: String, type:String, latitude:Double,longitude:Double ) {
        self.name = name
        self.placeid = placeid
        self.type = type
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        
    }
}

extension Place : MKAnnotation{
    var coordinate:CLLocationCoordinate2D{
        get{
            return location.coordinate
        }
    }
    
    var title: String?{
        get{
            return name
        }
    }
    var subtitle: String? {
        get {
            return type
        }
    }
    
    
}
