//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 4/2/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    // MARK: - Convert all studentLocations from Parse into an array of studentLocations
    
    func loadStudentLocations(completionHandlerForAllStudentLocationData: @escaping (_ result: [StudentLocation]?, _ error: NSError?) -> Void) {
        
        self.getStudentLocations() { (data: AnyObject?, error: NSError?) -> Void in
            if error != nil {
                print("Error getting StudentLocations: \(String(describing: error))")
                completionHandlerForAllStudentLocationData(nil, error)
            } else {
                guard let locations = data?[ParseRequest.ParseResponseKeys.results] as? [[String:AnyObject]] else {
                    print("There was an error getting StudentLocations out of the Parse data")
                    return
                }
                
                for dictionary in locations {
                    let studentLocation = StudentLocation(from: dictionary)
                    StudentLocation.allStudentLocations.append(studentLocation)
                }

                completionHandlerForAllStudentLocationData(StudentLocation.allStudentLocations, nil)
            }
        }
    }
    
    // MARK: - Check for existing pin
    
    // used in both MapView and List View
    func retrieveAnyExistingPin(completionHandlerForExistingPin: @escaping (_ result: StudentLocation?, _ error: NSError?) -> Void) {
        
        self.getStudentLocation() { (data: AnyObject?, error: NSError?) -> Void in
            if error != nil {
                print("There was an error retrieving this student's location: \(String(describing: error))")
                completionHandlerForExistingPin(nil, error)
            } else {
                
                guard let location = data?[ParseRequest.ParseResponseKeys.results] as? [[String:AnyObject]] else {
                    print("There was an error getting StudentLocations out of the Parse data")
                    return
                }
                
                var studentLocation: StudentLocation?
                
                if location.isEmpty {
                    let defaultDictionary = ["latitude": 0.0, "longitude": 0.0, "mapString": "", "firstName": "", "lastName": "", "mediaURL": "", "objectId": "", "uniqueKey": ParseUniqueKey] as [String : AnyObject]
                    studentLocation = StudentLocation(from: defaultDictionary)
                } else {
                    // convert data into a student location
                    let studentData = location[0]
                    studentLocation = StudentLocation(from: studentData)
                }
                
                guard let studentLocale = studentLocation else {
                    print("A studentLocation could not be made or found with this data.")
                    return
                }

                completionHandlerForExistingPin(studentLocale, nil)
            }
        }
    }
}
