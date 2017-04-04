//
//  ExtensionLoginViewController.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/30/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit


extension LoginViewController {
    
    // MARK: - Activity Indicator
    
    func addActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:100, height:100)) as UIActivityIndicatorView
        
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        
        self.view.addSubview(activityIndicator)
    }
    
    // MARK: - Keyboard Delegate
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        // gets the size of the user's keyboard
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        // shifts the view up the height of the keyboard (only on bottom text field)
        if passwordTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        // shifts the view down to the bottom when keyboard closes
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        // subscribes to keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        // unsubscribes to keyboard notifications
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
}
