//
//  OnTheMapNavigationSegues.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/30/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Segue to AddPinViewController

func segueToAddPinView(from viewController: UIViewController, studentLocation: StudentLocation) {
    
    DispatchQueue.main.async {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addPinView = storyboard.instantiateViewController(withIdentifier: "AddPinView") as! AddPinViewController
        addPinView.studentLocation = studentLocation
        viewController.navigationController?.pushViewController(addPinView, animated: true)
    }
}

// MARK: - Open student URLs in Safari

func transitionToWebsite(from viewController: UIViewController, urlString: String) {
    
    if let url = NSURL(string: urlString) {
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    } else {
        displayAlert(from: viewController, title: "Invalid URL", message: "This Student Has Provided an Invalid URL.")
    }
}

// MARK: - Complete logout/ Transition to LogIn

func transitionToLogIn(from viewController: UIViewController) {

    let loginView = viewController.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
    viewController.present(loginView, animated: true, completion: nil)
}
