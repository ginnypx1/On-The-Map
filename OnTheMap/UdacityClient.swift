//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/27/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient : NSObject {
    
    // MARK: Properties
    
    var session = URLSession.shared
    var udacityRequest = UdacityRequest()
    
    var userID: String? = nil
    
    // MARK: POST
    
    /*To authenticate Udacity API requests, you need to get a session ID. This is accomplished by using Udacity’s session method: https://www.udacity.com/api/session */
    
    func logInToUdacity(username: String, password: String, completionHandlerForLogin: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        /* Build the URL, Configure the request */
        let url = udacityRequest.buildURL(path: UdacityRequest.UdacityURL.SessionPath)
        var request = URLRequest(url: url)
        request.httpMethod = UdacityRequest.UdacityHTTPMethods.POST
        request.addValue(UdacityRequest.UdacityHeaderValues.JSON, forHTTPHeaderField: UdacityRequest.UdacityHeaderFields.Accept)
        request.addValue(UdacityRequest.UdacityHeaderValues.JSON, forHTTPHeaderField: UdacityRequest.UdacityHeaderFields.ContentType)
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    // improper credentials
                    if statusCode == 403 {
                        completionHandlerForLogin(nil, NSError(domain: "logInToUdacity", code: 403, userInfo: userInfo))
                    }
                }
                completionHandlerForLogin(nil, NSError(domain: "logInToUdacity", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            let range = Range(5 ..< data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            parseJSONDataWithCompletionHandler(newData, completionHandlerForData: completionHandlerForLogin)
        }
        
        /* Start the request */
        task.resume()
    }
    
    // MARK: - DELETE
    
    /* Delete the session ID to "logout". This is accomplished by using Udacity’s session method: https://www.udacity.com/api/session */
    
    func logOutOfUdacity(completionHandlerForLogout: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        /* Build the URL, Configure the request */
        let url = udacityRequest.buildURL(path: UdacityRequest.UdacityURL.SessionPath)
        var request = URLRequest(url: url)
        request.httpMethod = UdacityRequest.UdacityHTTPMethods.DELETE
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: UdacityRequest.UdacityHeaderFields.CookieValue)
        }
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForLogout(nil, NSError(domain: "logOutOfUdacity", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            let range = Range(5 ..< data.count)
            let newData = data.subdata(in: range) /* subset response data! */

            parseJSONDataWithCompletionHandler(newData, completionHandlerForData: completionHandlerForLogout)
        }
        
        /* Start the request */
        task.resume()
    }
    
    // MARK: - GET Public User Data
    
    /* retrieve basic user information before posting data to Parse. Method Name: https://www.udacity.com/api/users/<user_id> */
    
    func getUdacityUserData(completionHandlerForUserData: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        /* Build the URL, Configure the request */
        let url = udacityRequest.buildURL(path: UdacityRequest.UdacityURL.UserIdPath)
        var request = URLRequest(url: url)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForUserData(nil, NSError(domain: "getUdacityUserData", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx:)!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range) /* subset response data! */
            
            parseJSONDataWithCompletionHandler(newData, completionHandlerForData: completionHandlerForUserData)
        }
        
        /* Start the request */
        task.resume()
    }
    
}
