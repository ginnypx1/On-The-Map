//
//  StudentLocationModel.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/28/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit


// MARK: - StudentLocation

var allStudentLocations: [StudentLocation] = []

struct StudentLocation {
    
    var latitude: Double
    var longitude: Double
    var mapString: String
    
    var firstName: String
    var lastName: String
    var mediaURL: String
    
    var objectId: String
    var uniqueKey: String
    
    // MARK: - create a StudentLocation from a given dictionary
    
    init(from dictionary: [String:AnyObject]) {
        
        if let lat = dictionary[ParseRequest.ParseResponseKeys.latitude] as? Double {
            latitude = lat
        } else {
            latitude = 0.0
        }
        if let lon = dictionary[ParseRequest.ParseResponseKeys.longitude] as? Double {
            longitude = lon
        } else {
            longitude = 0.0
        }
        if let mapStr = dictionary[ParseRequest.ParseResponseKeys.mapString] as? String {
            mapString = mapStr
        } else {
            mapString = ""
        }
        if let first = dictionary[ParseRequest.ParseResponseKeys.firstName] as? String {
            firstName = first
        } else {
            firstName = ""
        }
        if let last = dictionary[ParseRequest.ParseResponseKeys.lastName] as? String {
            lastName = last
        } else {
            lastName = ""
        }
        if let studentURL = dictionary[ParseRequest.ParseResponseKeys.mediaURL] as? String {
            mediaURL = studentURL
        } else {
            mediaURL = ""
        }
        if let id = dictionary[ParseRequest.ParseResponseKeys.objectID] as? String {
            objectId = id
        } else {
            objectId = ""
        }
        if let key = dictionary[ParseRequest.ParseResponseKeys.uniqueKey] as? String {
            uniqueKey = key
        } else {
            uniqueKey = ""
        }
    }
}


