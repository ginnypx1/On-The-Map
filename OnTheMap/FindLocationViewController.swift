//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/29/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import MapKit
import SystemConfiguration

class FindLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    var activityIndicator: UIActivityIndicatorView!
    
    var udacityClient = UdacityClient()
    var parseClient = ParseClient()
    
    var studentLocation: StudentLocation?
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var firstName: String = ""
    var lastName: String = ""
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActivityIndicator()
        
        guard let studentLocation = self.studentLocation else {
            print("There is no studentLocation in the FindLocationViewController.")
            return
        }
        
        // check to see if this is a new pin
        if studentLocation.objectId == "" {
            // make the call to udacity to get first name and last name
            getNewStudentInformation() { () -> Void in
                self.getLatitudeAndLongitudeFromMapString(mapString: studentLocation.mapString)
            }
        } else {
            // extract latitude and longitude from mapString and create a map
            getLatitudeAndLongitudeFromMapString(mapString: studentLocation.mapString)
        }
    }
    
    // MARK: - Activity Indicator
    
    func addActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:100, height:100)) as UIActivityIndicatorView
        
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        
        self.view.addSubview(activityIndicator)
    }
    
    // MARK: - Hide the tab bar controller
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // use the studentLocation.mapString to get a latitude and longitude
    func getLatitudeAndLongitudeFromMapString(mapString: String)  {

        self.activityIndicator.startAnimating()
        
        CLGeocoder().geocodeAddressString(mapString, completionHandler: { (placemarks, error) in
            if error != nil {
                print("There was an error decoding the mapString: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        displayAlert(from: self, title: "No Internet Connection", message: "Make Sure Your Device is Connected to the Internet.")
                    } else {
                        displayAlert(from: self, title: "Location Not Found", message: "Could Not Geocode the Provided Location.")
                    }
                }
            } else {
                guard let placemarks = placemarks else {
                    print("There was no data recieved.")
                    return
                }
                if placemarks.count > 0 {
                    let placemark = placemarks[0]
                    let location = placemark.location
                    let coordinate = location?.coordinate
                    let latitude = (coordinate?.latitude)!
                    let longitude = (coordinate?.longitude)!
                    
                    self.latitude = latitude
                    self.longitude = longitude
                    
                    DispatchQueue.main.async {
                        self.loadMapOfLocation()
                    }
                }
            }
        })
    }
    
    // MARK: - Create Map
    
    func loadMapOfLocation() {
        
        guard let studentLocation = self.studentLocation else {
            print("Could not find a studentLocation to create the map.")
            return
        }
        
        let latitude = self.latitude
        let longitude = self.longitude
        let latDelta: CLLocationDegrees = 0.02
        let lonDelta: CLLocationDegrees = 0.02
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.mapView.setRegion(region, animated: true)
        
        // create the annotation for the studentLocation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
        annotation.subtitle = studentLocation.mediaURL
        
        // add the annotations to the map.
        self.activityIndicator.stopAnimating()
        self.mapView.addAnnotation(annotation)
    }
    
    // MARK: - New Pin
    
    func getNewStudentInformation(completionHandlerForData: @escaping () -> Void) {

        self.activityIndicator.startAnimating()
        
        // get firstName and lastName from Udacity
        self.udacityClient.getUdacityUserData() { (response: AnyObject?, error: NSError?) -> Void in
            if error != nil {
                print("There has been an error retrieving the user's Udacity data: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        displayAlert(from: self, title: "No Internet Connection", message: "Make Sure Your Device is Connected to the Internet.")
                    } else {
                        displayAlert(from: self, title: nil, message: "There Was an Error Retrieving the Student Data.")
                    }
                }
                return
            } else {
                guard let response = response else {
                    print("No Udacity student data was recieved.")
                    return
                }
                
                guard let userDictionary = response[UdacityRequest.UdacityParameterKeys.User] as? [String:AnyObject],
                    let firstName = userDictionary[UdacityRequest.UdacityResponseKeys.firstName] as? String,
                    let lastName = userDictionary[UdacityRequest.UdacityResponseKeys.lastName] as? String else {
                        print("The proper keys to unpack the Udacity user data were not in the response.")
                        return
                }
                
                self.firstName = firstName
                self.lastName = lastName
                
                completionHandlerForData()
            }
        }
    }
    
    func sendNewStudentLocation(studentLocation: StudentLocation) {

        self.activityIndicator.startAnimating()
        
        self.parseClient.createNewStudentLocation(studentLocation: studentLocation) { (response: AnyObject?, error: NSError?) -> Void in
            if error != nil {
                print("There was an error sending the new post to Parse: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        displayAlert(from: self, title: "No Internet Connection", message: "Make Sure Your Device is Connected to the Internet.")
                    } else {
                        displayAlert(from: self, title: "Request Failed", message: "There Was an Error Sending the Request for a New Location Pin.")                    }
                }
            } else {
                guard let response = response, (response[ParseRequest.ParseResponseKeys.creationDate]) != nil else {
                    print("No pin was created.")
                    return
                }

                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tabBarController?.tabBar.isHidden = false
                    self.navigationController?.popToRootViewController(animated:true)
                }
            }
        }
    }
    
    // MARK: - Updated Pin
    
    func sendUpdatedStudentLocation(studentLocation: StudentLocation) {

        self.activityIndicator.startAnimating()
        
        self.parseClient.updateStudentLocation(studentLocation: studentLocation) { (response: AnyObject?, error: NSError?) -> Void in
            if error != nil {
                print("There was an error sending updated post to Parse: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        displayAlert(from: self, title: "No Internet Connection", message: "Make Sure Your Device is Connected to the Internet.")
                    } else {
                        displayAlert(from: self, title: nil, message: "There Was an Error Retrieving Student Data.")
                    }
                }
            } else {
                guard let response = response, (response[ParseRequest.ParseResponseKeys.creationDate]) != nil else {
                    print("The pin was not updated.")
                    displayAlert(from: self, title: "Request Failed", message: "There Was an Error Updating the Location Pin.")
                    return
                }

                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tabBarController?.tabBar.isHidden = false
                    self.navigationController?.popToRootViewController(animated:true)
                }
            }
        }
    }
    
    // MARK: - Complete Add Pin
    
    @IBAction func finishAddingLocation() {
        
        guard var studentLocation = self.studentLocation else {
            print("A studentLocation could not be found.")
            return
        }
        
        // check for newStudentLocation
        if studentLocation.objectId == "" {

            studentLocation.latitude = self.latitude
            studentLocation.longitude = self.longitude
            studentLocation.firstName = self.firstName
            studentLocation.lastName = self.lastName

            self.sendNewStudentLocation(studentLocation: studentLocation)
            
        } else {
            // update existing pin
            studentLocation.latitude = self.latitude
            studentLocation.longitude = self.longitude

            self.sendUpdatedStudentLocation(studentLocation: studentLocation)
        }
    }

}
