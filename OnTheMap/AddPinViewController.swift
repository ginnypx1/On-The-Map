//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/26/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit

class AddPinViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    // MARK: - Properties
    
    let onTheMapTextFieldDelegate = OnTheMapTextFieldDelegate()
    
    var studentLocation: StudentLocation?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set text field delegate
        locationTextField.delegate = onTheMapTextFieldDelegate
        websiteTextField.delegate = onTheMapTextFieldDelegate
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
                displayAlert(from: self, title: nil, message: "Please Provide a Location and a Valid URL.")
                return
            }
            
            guard var studentLocation = self.studentLocation else {
                print("There is no studentLocation to alter.")
                return
            }
            
            // reset studentLocation values for mapString and mediaURL
            studentLocation.mapString = locationText
            studentLocation.mediaURL = websiteText
            
            // segue to LocationView
            let findLocationView = self.storyboard?.instantiateViewController(withIdentifier: "FindLocationView") as! FindLocationViewController
            findLocationView.studentLocation = studentLocation
            self.navigationController?.pushViewController(findLocationView, animated: true)
            
            
        } else {
            displayAlert(from: self, title: nil, message: "Please Provide a Location and a Valid URL Including HTTP(S)://")
        }
    }
}
