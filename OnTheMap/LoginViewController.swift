
//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/24/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import SystemConfiguration

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    
    var udacityClient = UdacityClient()
    
    let onTheMapTextFieldDelegate = OnTheMapTextFieldDelegate()
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        // set text field delegate
        emailTextField.delegate = onTheMapTextFieldDelegate
        passwordTextField.delegate = onTheMapTextFieldDelegate
        // add activity indicator
        addActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // unsubscribe to keyboard notifications
        unsubscribeToKeyboardNotifications()
    }
    
    // MARK: - Log In
    
    private func completeLogin(success: Bool) {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            if success {
                // transition to map view
                let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.present(tabBarController, animated: true)
            } else {
                // alert login failure
                displayAlert(from: self, title: nil, message: "There Was an Error Logging In. Please Try Again.")
            }
        }
    }

    @IBAction func logIn(_ sender: Any) {
        
        // make sure there is text in the email and password fields
        if onTheMapTextFieldDelegate.validateTextFields(emailTextField, passwordTextField) == true {
            // store the email and password
            if let username = emailTextField.text, let password = passwordTextField.text {
                self.activityIndicator.startAnimating()
                
                // make a login request with Udacity
                udacityClient.logInToUdacity(username: username, password: password) { (data: AnyObject?, error: NSError?) -> Void in
                    
                    if error != nil {
                        print("Error from LogInToUdacity Method: \(String(describing: error)))")
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            if error?.code == 403 {
                                // Alert invalid credentials
                                displayAlert(from: self, title: nil, message: "The Username and Password Combination Provided Was Incorrect. Please Try Again.")
                            } else if isInternetAvailable() == false {
                                // Alert no internet
                                displayAlert(from: self, title: "No Internet Connection", message: "Make Sure Your Device is Connected to the Internet.")
                            } else {
                                // Alert login failure
                                displayAlert(from: self, title: nil, message: "There Was an Error During the Login Process. Please Try Again.")
                            }
                        }
                    }
                    
                    guard let data = data else {
                            print("No user and session data was recieved.")
                            return
                    }
                    
                    // check for login success
                    self.udacityClient.getUdacityUserID(data: data) { (success: Bool) -> Void in
                        self.completeLogin(success: success)
                    }
                }
            }
        // there is no text in the username or password field
        } else {
            displayAlert(from: self, title: nil, message: "Please Enter a Username and Password.")
        }
    }
    
    // MARK: - Sign Up

    // opens Udacity.com SignUp page in Safari
    @IBAction func signUp(_ sender: Any) {

        if let url = NSURL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}

