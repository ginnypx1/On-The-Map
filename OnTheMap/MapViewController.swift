//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/26/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import MapKit
import SystemConfiguration

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var parseClient: ParseClient = ParseClient()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add activity indicator
        addActivityIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // load Map Data
        loadMapData()
    }
    
    // MARK: - Activity Indicator
    
    func addActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:100, height:100)) as UIActivityIndicatorView
        
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        
        self.view.addSubview(activityIndicator)
    }
    
    // MARK: - Create a map of all the studentLocations
    
    // retrieve studentLocation data and load into the mapView
    func loadMapData() {

        removeAllMapAnnotations()
        self.activityIndicator.startAnimating()
        
        self.parseClient.loadStudentLocations() { (locations: [StudentLocation]?, error: NSError?) -> Void in
            
            if error != nil {
                print("There was an error turning the data into a map: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        displayAlert(from: self, title: "No Internet Connection", message: "Make Sure Your Device is Connected to the Internet.")
                    } else {
                        displayAlert(from: self, title: nil, message: "There Was an Error Retrieving the Student Data.")
                    }
                }
            } else {
                if let locations = locations {
                    // create map of data
                    self.createStudentLocationMap(with: locations)
                }
            }
        }
    }
    
    // create a map out of the data
    func createStudentLocationMap(with locations: [StudentLocation]) {
        
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in locations {
            // create a CLLocationCoordinates2D instance
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // create the annotation and set its coordinate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.mediaURL
            
            // place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // add the annotations to the map.
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
            self.activityIndicator.stopAnimating()
        }
    }

    // MARK: - MKMapViewDelegate

    // create a view with a "right callout accessory view"
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // tap on pin to open studentLocation.mediaURL
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
        if control == annotationView.rightCalloutAccessoryView {
            
            guard let mediaURLString = annotationView.annotation?.subtitle as? String else {
                displayAlert(from: self, title: "Website Not Found", message: "The Link Provided By the Student Was Invalid.")
                return
            }
            
            if mediaURLString.hasPrefix("https://") || mediaURLString.hasPrefix("http://") {
                transitionToWebsite(from: self, urlString: mediaURLString)
            } else {
                displayAlert(from: self, title: "Invalid URL", message: "This Student Has Provided an Invalid Link.")
            }
        }
    }
    
    // remove previous map annotations
    func removeAllMapAnnotations() {
        for annotation in self.mapView.annotations {
            self.mapView.removeAnnotation(annotation)
        }
    }

    // MARK: - Add Pin
    
    // add a pin to the map or update an existing pin
    @IBAction func addPin(_ sender: Any) {

        self.activityIndicator.startAnimating()
        
        // check with Parse about pin state
        self.parseClient.retrieveAnyExistingPin() { (studentLocation: StudentLocation?, error: NSError?) -> Void in
            
            if error != nil {
                print("There was a problem checking for an existing student location.")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        displayAlert(from: self, title: "No Internet Connection", message: "Make Sure Your Device is Connected to the Internet.")
                    } else {
                        displayAlert(from: self, title: nil, message: "There Was an Error Retrieving the Student Data.")
                        
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
                // else alert that a pin already exists and give choice to overwrite
                } else {
                    self.activityIndicator.stopAnimating()
                    displayOverwriteAlert(from: self, studentLocation: studentLocation)
                }
            }
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
                    transitionToLogIn(from: self)
                }
            } else {
                displayAlert(from: self, title: "Logout Unsuccessful", message: "Please try again.")
            }
        }
    }
    
    // MARK: - Refresh Map Data
    
    // reload the map data
    @IBAction func refreshMapData(_ sender: Any) {
        loadMapData()
    }

}
    


