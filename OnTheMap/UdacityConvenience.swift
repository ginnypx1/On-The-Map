//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 4/2/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    // MARK: - Get User Id to start session
    
    func getUdacityUserID(data: AnyObject, completionHandlerForUserID: @escaping (_ success: Bool) -> Void) {
        
        guard let sessionDict = data[UdacityRequest.UdacityResponseKeys.session] as? [String: AnyObject],
            let _ = sessionDict[UdacityRequest.UdacityResponseKeys.id] as? String else {
                print("The required session keys were not in the data.")
                completionHandlerForUserID(false)
                return
        }
        
        guard let accountDict = data[UdacityRequest.UdacityResponseKeys.account] as? [String:AnyObject],
            let userId = accountDict[UdacityRequest.UdacityResponseKeys.key] as? String else {
                print("The required account keys were not in the data.")
                completionHandlerForUserID(false)
                return
        }
        
        self.userID = userId
        ParseUniqueKey = userId
        
        completionHandlerForUserID(true)
    }
    
    // MARK: - Log user out of Udacity
    
    func logOut(completionHandlerForLogout: @escaping (_ success: Bool) -> Void) {
        
        self.logOutOfUdacity() { (response: AnyObject?, error: NSError?) -> Void in
            if error != nil {
                print("User could not be logged out of Udacity: \(String(describing: error))")
                completionHandlerForLogout(false)
                return
            } else {
                guard let response = response?[UdacityRequest.UdacityResponseKeys.session] as? [String: AnyObject],
                    (response[UdacityRequest.UdacityResponseKeys.expiration]) != nil else {
                        print("The logout response keys were not in the data.")
                        return
                }
                completionHandlerForLogout(true)
            }
        }
    }
    
}
