//
//  Alert.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-25.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class Alert {
    
    // Display the most basic message alert
    class func displayBasicAlert(title: String, message: String, button: String = "Ok", in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: button, style: .cancel, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // Deleting DataCore for testing purposes
    class func deleteCoreData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            for managedObject in results {
                if let managedObjectData = managedObject as? NSManagedObject {
                    managedContext.delete(managedObjectData)
                }
            }
        }
        catch {
            print(error)
        }
    }
    
}
