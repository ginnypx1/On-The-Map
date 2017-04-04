//
//  UdacityRequestModel.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/27/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation

struct UdacityRequest {
    
    // MARK: - Properties
    
    struct UdacityURL {
        static let Scheme: String = "https"
        static let Host: String = "www.udacity.com"
        static let SessionPath: String = "/api/session"
        static let UserIdPath: String = "/api/users/me"
    }
    
    struct UdacityHTTPMethods {
        static let POST: String = "POST"
        static let GET: String = "GET"
        static let DELETE: String = "DELETE"
    }
    
    struct UdacityHeaderFields {
        static let Accept: String = "Accept"
        static let ContentType: String = "Content-Type"
        static let CookieValue: String = "X-XSRF-TOKEN"
    }
    
    struct UdacityHeaderValues {
        static let JSON: String = "application/json"
    }
    
    struct UdacityParameterKeys {
        static let User: String = "user"
    }
    
    struct UdacityResponseKeys {
        static let account: String = "account"
        static let session: String = "session"
        static let key: String = "key"
        static let id: String = "id"
        static let firstName: String = "first_name"
        static let lastName: String = "last_name"
        static let expiration: String = "expiration"
    }
    
    func buildURL(path: String) -> URL {
        var components = URLComponents()
        components.scheme = UdacityURL.Scheme
        components.host = UdacityURL.Host
        components.path = path
        return components.url!
    }
    
}
