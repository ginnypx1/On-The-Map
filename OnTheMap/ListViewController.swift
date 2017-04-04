//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/26/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import SystemConfiguration

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var parseClient = ParseClient()
    
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add activity indicator
        addActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // load table data
        self.loadTableData()
    }
    
    // MARK: - Activity Indicator
    
    func addActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:100, height:100)) as UIActivityIndicatorView
        
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        
        self.view.addSubview(activityIndicator)
    }

    // MARK: - Table View Delegate
    
    // return number of StudentLocations in locations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return StudentLocation.allStudentLocations.count
    }
    
    // create a StudentLocationTableViewCell, populate it with locations
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as! StudentLocationTableViewCell
        
        // populates the table row with studentLocation data
        let studentLocation = StudentLocation.allStudentLocations[(indexPath as NSIndexPath).row]
        
        let first = studentLocation.firstName
        let last = studentLocation.lastName
        let mediaURL = studentLocation.mediaURL
        
        cell.studentNameLabel?.text = "\(first) \(last)"
        cell.studentWebsiteLabel?.text = "\(mediaURL)"
        
        return cell
    }

    
    // turn the studentLocation mediaURL into a URL
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let studentLocation = StudentLocation.allStudentLocations[indexPath.row]
        let mediaURLString = studentLocation.mediaURL
        
        if mediaURLString.hasPrefix("https://") || mediaURLString.hasPrefix("http://") {
            transitionToWebsite(from: self, urlString: mediaURLString)
        } else {
            OnTheMapAlerts.displayAlert(from: self, title: "Invalid URL", message: "This Student Has Provided an Invalid Link.")
        }
    }
    
    // MARK: - Logout
    
    // Log the user out of Udacity
    @IBAction func logOut(_ sender: Any) {

        let udacityClient = UdacityClient()
        self.activityIndicator.startAnimating()
        
        udacityClient.logOut() { (success: Bool) in
            if success {
                DispatchQueue.main.sync {
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated:true,completion:nil)
                }
            } else {
                OnTheMapAlerts.displayAlert(from: self, title: "Logout Unsuccessful", message: "Please try again.")
            }
        }
    }
    
    // MARK: - Load Table Data
    
    // retrieves the studentLocation data from Parse and loads it into the tableView
    func loadTableData() {

        StudentLocation.allStudentLocations.removeAll()
        
        self.activityIndicator.startAnimating()
        
        self.parseClient.loadStudentLocations() { (locations: [StudentLocation]?, error: NSError?) -> Void in
            
            if error != nil {
                print("There was an error turning the locations into a table: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        OnTheMapAlerts.displayInternetConnectionAlert(from: self)
                    } else {
                        OnTheMapAlerts.displayStandardAlert(from: self)
                        
                    }
                }
            } else {
                if let locations = locations {
                    StudentLocation.allStudentLocations = locations
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    // refresh table data
    @IBAction func reloadListData(_ sender: Any) {
        self.loadTableData()
    }
    
    // MARK: - Add Pin
    
    // allows user to create a pin or edit an existing pin
    @IBAction func addPin(_ sender: Any) {

        self.activityIndicator.startAnimating()
        self.parseClient.retrieveAnyExistingPin() { (studentLocation: StudentLocation?, error: NSError?) -> Void in
            
            if error != nil {
                print("There was a problem checking for an existing student location.")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        OnTheMapAlerts.displayInternetConnectionAlert(from: self)
                    } else {
                        OnTheMapAlerts.displayStandardAlert(from: self)
                    }
                }
            } else {
                guard let studentLocation = studentLocation else {
                    print("No studentLocation was retrieved.")
                    return
                }
                
                // if it is a new request, segue to AddPinView
                if studentLocation.objectId == "" {
                    segueToAddPinView(from: self, studentLocation: studentLocation)
                //alert that a pin already exists and give choice to overwrite
                } else {
                    self.activityIndicator.stopAnimating()
                    OnTheMapAlerts.displayOverwriteAlert(from: self, studentLocation: studentLocation)
                }
            }
        }
    }

}
