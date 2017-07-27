//
//  CoreData.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-26.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreData {
    
    // Deleting DataCore
    class func deleteCoreData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        }
        catch {
            print(error)
        }
    }
    
}
