//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/26/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import MapKit
import SystemConfiguration

class AddPinViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    // MARK: - Properties
    
    let onTheMapTextFieldDelegate = OnTheMapTextFieldDelegate()
    
    var activityIndicator: UIActivityIndicatorView!
    
    var studentLocation: StudentLocation?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set text field delegate
        locationTextField.delegate = onTheMapTextFieldDelegate
        websiteTextField.delegate = onTheMapTextFieldDelegate
        // add activity indicator
        addActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        // hide the tab bar controller
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // unsubscribe to keyboard notifications
        unsubscribeToKeyboardNotifications()
    }
    
    // MARK: - Geocode the mapString
    
    // use the studentLocation.mapString to get a latitude and longitude
    func getLatitudeAndLongitudeFromMapString(mapString: String, completionHandlerForCoordinates: @escaping (_ coordinate: (Double, Double)) -> Void)  {
        
        self.activityIndicator.startAnimating()
        
        CLGeocoder().geocodeAddressString(mapString, completionHandler: { (placemarks, error) in
            if error != nil {
                print("There was an error decoding the mapString: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        OnTheMapAlerts.displayInternetConnectionAlert(from: self)
                    } else {
                        OnTheMapAlerts.displayAlert(from: self, title: "Location Not Found", message: "Could Not Geocode the Provided Location.")
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
                    
                    completionHandlerForCoordinates((latitude, longitude))
                }
            }
        })
    }

    
    // MARK: - Cancel Add Pin
    
    // cancels add pin and returns the user to their previous table or map view
    @IBAction func cancelAddPin(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated:true)
    }
    
    // MARK: - Add new information to StudentLocation
    
    // verifies the user's location on the FindLocationViewController
    @IBAction func findLocation(_ sender: Any) {
        
        // set text field variables 
        if onTheMapTextFieldDelegate.validateLocationFields(locationTextField, websiteTextField) == true {
            
            // grab the text field values
            guard let locationText = self.locationTextField.text, let websiteText = self.websiteTextField.text else {
                print("The text fields were empty.")
                OnTheMapAlerts.displayAlert(from: self, title: nil, message: "Please Provide a Location and a Valid URL.")
                return
            }
            
            guard var studentLocation = self.studentLocation else {
                print("There is no studentLocation to alter.")
                return
            }
            
            // extract the latitude and longitude from the provided location
            self.getLatitudeAndLongitudeFromMapString(mapString: locationText) { (coordinate: (Double, Double)) -> Void in
                
                // reset studentLocation values for latitude, longitude, mapString and mediaURL
                studentLocation.latitude = coordinate.0
                studentLocation.longitude = coordinate.1
                studentLocation.mapString = locationText
                studentLocation.mediaURL = websiteText
                
                // segue to LocationView
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    let findLocationView = self.storyboard?.instantiateViewController(withIdentifier: "FindLocationView") as! FindLocationViewController
                    findLocationView.studentLocation = studentLocation
                    self.navigationController?.pushViewController(findLocationView, animated: true)
                }
            }
            
        } else {
            OnTheMapAlerts.displayAlert(from: self, title: nil, message: "Please Provide a Location and a Valid URL Including HTTP(S)://")
        }
    }
}
