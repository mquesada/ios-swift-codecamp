//
//  UserLocation.swift
//  yelp
//
//  Created by Maricel Quesada on 10/4/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//
import CoreLocation

class UserLocation {
    
    var currentLocationStr : String!
    var currentLocation : CLLocation {
        didSet {
            CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error)->Void in
                if (error != nil) {
                    println("Reverse geocoder failed with error = " + error.localizedDescription)
                    return
                }
                
                if placemarks.count > 0 {
                    let placemark = placemarks[0] as CLPlacemark
                    
                    if (placemark.locality != nil && placemark.administrativeArea != nil) {
                        self.currentLocationStr = "\(placemark.locality),\(placemark.administrativeArea)"
                    }
                } else {
                    println("Problem with the data received from geocoder")
                }
            })
        }
    }
    
    init() {
        currentLocation = CLLocation(latitude: 37.3874329, longitude: -121.9949027)
        currentLocationStr = "Sunnyvale,CA"
    }
    
    var latitude: Double {
        get {
            return self.currentLocation.coordinate.latitude
        }
    }
    
    var longitude: Double {
        get {
            return self.currentLocation.coordinate.longitude
        }
    }
    
    
    
}
