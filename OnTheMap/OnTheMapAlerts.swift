//
//  OnTheMapAlerts.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/30/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Alerts


// alert that login information was not correct
func displayAlert(from viewController: UIViewController, title: String?, message: String) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action: UIAlertAction) -> Void in
        alertController.dismiss(animated: true, completion: nil)
    }
    
    // Change font of the title and message
    let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 14)! ]
    let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
    alertController.setValue(attributedMessage, forKey: "attributedMessage")
    
    // add actions to alert controller
    alertController.addAction(dismissAction)
    
    viewController.present(alertController, animated: true, completion: nil)
}


// alert user of existing pin
func displayOverwriteAlert(from viewController: UIViewController, studentLocation: StudentLocation) {
    
    let alertController = UIAlertController(title: nil, message: "User \"\(studentLocation.firstName) \(studentLocation.lastName)\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?", preferredStyle: .alert)
    
    // create actions for alert controller
    let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (action: UIAlertAction) -> Void in
        segueToAddPinView(from: viewController, studentLocation: studentLocation)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in
        alertController.dismiss(animated: true, completion: nil)
    }
    
    // Change font of the title and message
    let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 14)! ]
    let attributedMessage = NSMutableAttributedString(string: "User \"\(studentLocation.firstName) \(studentLocation.lastName)\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?", attributes: messageFont)
    alertController.setValue(attributedMessage, forKey: "attributedMessage")
    
    // add actions to alert controller
    alertController.addAction(overwriteAction)
    alertController.addAction(cancelAction)
    
    viewController.present(alertController, animated: true, completion: nil)
}

