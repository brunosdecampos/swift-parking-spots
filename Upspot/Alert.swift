//
//  Alert.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-25.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import Foundation
import UIKit

public class Alert {
    
    // Display the most basic message alert
    class func displayBasicAlert(title: String, message: String, button: String = "Ok", in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: button, style: .cancel, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
