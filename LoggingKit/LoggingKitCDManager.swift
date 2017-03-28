//
//  LoggingKitCDManager.swift
//  LoggingKit
//
//  Created by ramon.pineda on 12/13/16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoggingKitCDManager : NSObject
{

    override init()
    {
        super.init()
        do {
            let frameworkBundle = Bundle(identifier:"home.LoggingKit")
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            var dict:NSDictionary?
            
            if let path = frameworkBundle?.path(forResource: "Info", ofType: "plist") {
                dict = NSDictionary(contentsOfFile: path)
            }
            
            if let plist = dict {
                let storeURL = docURL.appendingPathComponent(plist.object(forKey: "SQLite") as! String) //SQLite file name
                do
                {
                    try self.manageObjectContext.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                }
                catch
                {
                    fatalError("Error migrating store: \(error)")
                }
                try self.manageObjectContext.save()
            }

        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }

    lazy var manageObjectModel: NSManagedObjectModel = {
        let frameworkBundle = Bundle(identifier:"home.LoggingKit")
        let path = frameworkBundle?.path(forResource: "LoggingKitCoreData", ofType: "mom")
        guard let mom = NSManagedObjectModel(contentsOf: NSURL(fileURLWithPath:path!) as URL) else {
            fatalError("Error loading model from bundle")
        }
        return mom
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.manageObjectModel)
        return psc
    }()
    
    lazy var manageObjectContext:NSManagedObjectContext = {
        var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        manageObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return manageObjectContext
    }()

    func saveContext() {
        let context = self.manageObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

}
