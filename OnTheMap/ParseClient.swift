//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/27/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

class ParseClient : NSObject {
    
    // MARK: Properties
    
    var session = URLSession.shared
    
    var parseRequest = ParseRequest()
    
    // MARK: GET
    
    /* To get a single student location: https://parse.udacity.com/parse/classes/StudentLocation */
    
    func getStudentLocation(completionHandlerForGETStudentLocation: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        /* Set the Parameters */
        var parametersWithUniqueKey: [String: AnyObject] = [ParseRequest.ParseParameterKeys.WithParameters: "{\"\(ParseRequest.ParseParameterKeys.UniqueKey)\":\"\(ParseUniqueKey)\"}" as AnyObject]
        
        /* Build the URL */
        var getRequestURL = parseRequest.buildURLWithParameters(path: ParseRequest.ParseURL.GetPath, parameters: parametersWithUniqueKey)
        
        /* Configure the request */
        let request = NSMutableURLRequest(url: getRequestURL)
        request.addValue(ParseRequest.ParseValues.ApplicationID, forHTTPHeaderField: ParseRequest.ParseHeaderFields.ApplicationID)
        request.addValue(ParseRequest.ParseValues.RestAPIKey, forHTTPHeaderField: ParseRequest.ParseHeaderFields.RestAPIKey)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETStudentLocation(nil, NSError(domain: "getStudentLocation", code: 1, userInfo: userInfo))
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
            
            /* Parse the Parse data and use the data (happens in completion handler) */
            parseJSONDataWithCompletionHandler(data, completionHandlerForData: completionHandlerForGETStudentLocation)
        }
        
        /* Start the request */
        task.resume()
    }

    
    /* To get multiple student locations at one time: https://parse.udacity.com/parse/classes/StudentLocation */
    
    func getStudentLocations(completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        /* Set the Parameters */
        var loadLimit = 100
        var loadOrder = "-updatedAt"
        var parameters: [String: AnyObject] = [ParseRequest.ParseParameterKeys.DataLimit: (loadLimit as AnyObject),
                                               ParseRequest.ParseParameterKeys.WithOrder: (loadOrder as AnyObject)]
        
        /* Build the URL */
        var getRequestURL = parseRequest.buildURLWithParameters(path: ParseRequest.ParseURL.GetPath, parameters: parameters)
        
        /* Configure the request */
        let request = NSMutableURLRequest(url: getRequestURL)
        request.addValue(ParseRequest.ParseValues.ApplicationID, forHTTPHeaderField: ParseRequest.ParseHeaderFields.ApplicationID)
        request.addValue(ParseRequest.ParseValues.RestAPIKey, forHTTPHeaderField: ParseRequest.ParseHeaderFields.RestAPIKey)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo))
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
            
            /* Parse the Parse data and use the data (happens in completion handler) */
            
            parseJSONDataWithCompletionHandler(data, completionHandlerForData: completionHandlerForGET)
        }
        
        /* Start the request */
        task.resume()
    }
    
    // MARK: - POST
    
    /* To create a new student location: https://parse.udacity.com/parse/classes/StudentLocation */
    
    func createNewStudentLocation(studentLocation: StudentLocation, completionHandlerForPOSTNewStudentLocation: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        /* Build the URL */
        var postRequestURL = parseRequest.buildURL(path: ParseRequest.ParseURL.GetPath)
        
        /* Configure the request */
        let request = NSMutableURLRequest(url: postRequestURL)
        request.httpMethod = ParseRequest.ParseHTTPMethods.POST
        request.addValue(ParseRequest.ParseValues.ApplicationID, forHTTPHeaderField: ParseRequest.ParseHeaderFields.ApplicationID)
        request.addValue(ParseRequest.ParseValues.RestAPIKey, forHTTPHeaderField: ParseRequest.ParseHeaderFields.RestAPIKey)
        request.addValue(ParseRequest.ParseValues.JSON, forHTTPHeaderField: ParseRequest.ParseHeaderFields.ContentType)
        request.httpBody = "{\"uniqueKey\": \"\(ParseUniqueKey)\", \"firstName\": \"\(studentLocation.firstName)\", \"lastName\": \"\(studentLocation.lastName)\",\"mapString\": \"\(studentLocation.mapString)\", \"mediaURL\": \"\(studentLocation.mediaURL)\",\"latitude\": \(studentLocation.latitude), \"longitude\": \(studentLocation.longitude)}".data(using: String.Encoding.utf8)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOSTNewStudentLocation(nil, NSError(domain: "createNewStudentLocation", code: 1, userInfo: userInfo))
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
            
            /* Parse the Parse data and use the data (happens in completion handler) */
            parseJSONDataWithCompletionHandler(data, completionHandlerForData: completionHandlerForPOSTNewStudentLocation)
        }
        
        /* Start the request */
        task.resume()
    }
    
    // MARK: - PUT
    
    /* To update an existing student location: https://parse.udacity.com/parse/classes/StudentLocation/<objectId> */
    
    func updateStudentLocation(studentLocation: StudentLocation, completionHandlerForPUTStudentLocation: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        /* Build the URL */
        var putRequestURL = parseRequest.buildURL(path: "\(ParseRequest.ParseURL.GetPath)/\(studentLocation.objectId)")
        
        /* Configure the request */
        let request = NSMutableURLRequest(url: putRequestURL)
        request.httpMethod = ParseRequest.ParseHTTPMethods.PUT
        request.addValue(ParseRequest.ParseValues.ApplicationID, forHTTPHeaderField: ParseRequest.ParseHeaderFields.ApplicationID)
        request.addValue(ParseRequest.ParseValues.RestAPIKey, forHTTPHeaderField: ParseRequest.ParseHeaderFields.RestAPIKey)
        request.addValue(ParseRequest.ParseValues.JSON, forHTTPHeaderField: ParseRequest.ParseHeaderFields.ContentType)
        request.httpBody = "{\"uniqueKey\": \"\(ParseUniqueKey)\", \"firstName\": \"\(studentLocation.firstName)\", \"lastName\": \"\(studentLocation.lastName)\",\"mapString\": \"\(studentLocation.mapString)\", \"mediaURL\": \"\(studentLocation.mediaURL)\",\"latitude\": \(studentLocation.latitude), \"longitude\": \(studentLocation.longitude)}".data(using: String.Encoding.utf8)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUTStudentLocation(nil, NSError(domain: "updateStudentLocation", code: 1, userInfo: userInfo))
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
            
            /* Parse the Parse data and use the data (happens in completion handler) */
            parseJSONDataWithCompletionHandler(data, completionHandlerForData: completionHandlerForPUTStudentLocation)
        }
        
        /* Start the request */
        task.resume()
    }

}
