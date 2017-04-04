//
//  OnTheMapTests.swift
//  OnTheMapTests
//
//  Created by Ginny Pennekamp on 3/24/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import XCTest
@testable import OnTheMap

class OnTheMapTests: XCTestCase {
    
    var parseRequestUnderTest: ParseRequest!
    var udacityRequestUnderTest: UdacityRequest!
    
    override func setUp() {
        super.setUp()
        parseRequestUnderTest = ParseRequest()
        udacityRequestUnderTest = UdacityRequest()
    }
    
    override func tearDown() {
        parseRequestUnderTest = nil
        udacityRequestUnderTest = nil
        super.tearDown()
    }
    
    func testUdacityLoginLogoutRequestURL() {
        let expectedOutput = URL(string: "https://www.udacity.com/api/session")!
        let input = udacityRequestUnderTest.buildURL(path: UdacityRequest.UdacityURL.SessionPath)
        XCTAssertEqual(input, expectedOutput, "The URL for Udacity Login/ Logout is NOT correct")
    }
    
    func testParseBuildURLWithParameters() {
        let loadLimit = 200
        let parametersWithLimit: [String: AnyObject] = ["limit": (loadLimit as AnyObject)]
        
        let expectedOutput = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=200")!
        let input = parseRequestUnderTest.buildURLWithParameters(path: ParseRequest.ParseURL.GetPath, parameters: parametersWithLimit)
        XCTAssertEqual(input, expectedOutput, "The URL for Parse GET StudentLocations is NOT correct")
    }
    
}
