//
//  OnTheMapTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Ginny Pennekamp on 3/29/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

class OnTheMapTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // clears the textField of default text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // allows use of the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // checks that there is a value in all text fields
    func validateTextFields(_ textField1: UITextField, _ textField2: UITextField) -> Bool {
        if (textField1.text?.isEmpty)! || (textField2.text?.isEmpty)! {
            return false
        } else {
            return true
        }
    }
    
    // checks that there is a location and that website begins with http
    func validateLocationFields(_ textField1: UITextField, _ textField2: UITextField) -> Bool {
        if let urlText = textField2.text?.lowercased() {
            if (textField1.text?.isEmpty)! || !(urlText.hasPrefix("http")) {
                return false
            }
        }
        return true
    }

}
