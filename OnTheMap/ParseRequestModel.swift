//
//  ParseRequestModel.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/27/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation


var ParseUniqueKey: String = ""


struct ParseRequest {
    
    // MARK: - Properties
    
    struct ParseURL {
        static let Scheme: String = "https"
        static let Host: String = "parse.udacity.com"
        static let GetPath: String = "/parse/classes/StudentLocation"
    }
    
    struct ParseValues {
        static let ApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let JSON: String = "application/json"
    }
    
    struct ParseHTTPMethods {
        static let GET: String = "GET"
        static let POST: String = "POST"
        static let PUT: String = "PUT"
    }
    
    struct ParseHeaderFields {
        static let ApplicationID: String = "X-Parse-Application-Id"
        static let RestAPIKey: String = "X-Parse-REST-API-Key"
        static let ContentType: String = "Content-Type"
    }
    
    struct ParseParameterKeys {
        static let UniqueKey: String = "uniqueKey"
        static let DataLimit: String = "limit"
        static let WithParameters: String = "where"
        static let WithOrder: String = "order"
    }
    
    struct ParseResponseKeys {
        static let results: String = "results"
        static let objectID: String = "objectId"
        static let firstName: String = "firstName"
        static let lastName: String = "lastName"
        static let mapString: String = "mapString"
        static let mediaURL: String = "mediaURL"
        static let latitude: String = "latitude"
        static let longitude: String = "longitude"
        static let creationDate: String = "createdAt"
        static let lastUpdated: String = "updatedAt"
        static let uniqueKey: String = "uniqueKey"
        
    }
    
    func buildURL(path: String) -> URL {
        var components = URLComponents()
        components.scheme = ParseURL.Scheme
        components.host = ParseURL.Host
        components.path = path
        return components.url!
    }
    
    func buildURLWithParameters(path: String, parameters: [String:AnyObject]) -> URL {
    
        var components = URLComponents()
        components.scheme = ParseURL.Scheme
        components.host = ParseURL.Host
        components.path = path
        components.queryItems = [URLQueryItem]()
    
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
}
