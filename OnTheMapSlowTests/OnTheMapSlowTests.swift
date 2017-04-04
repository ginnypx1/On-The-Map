//
//  OnTheMapSlowTests.swift
//  OnTheMapSlowTests
//
//  Created by Ginny Pennekamp on 3/28/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import XCTest
@testable import OnTheMap


class OnTheMapSlowTests: XCTestCase {
    
    // MARK: - Test Properties
    
    var sessionUnderTest: URLSession!
    
    var UdacityURLUnderTest: URL = URL(string: "https://www.udacity.com/api/session")!
    
    // MARK: - Set Up, Tear Down
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    // MARK: - Test Udacity POST call
    
    // Asynchronous test: success fast, failure slow
    func testValidCallToUdacityAPIGetsHTTPStatusCode200() {
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sessionUnderTest.dataTask(with: UdacityURLUnderTest) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Asynchronous test: faster fail
    func testCallToUdacityAPICompletes() {
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        let dataTask = sessionUnderTest.dataTask(with: UdacityURLUnderTest) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    // TODO: Test Parse call but have to do it while logged in to Udacity
    
}
