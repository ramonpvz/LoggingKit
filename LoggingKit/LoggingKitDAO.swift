//
//  LoggingKitDAO.swift
//  LoggingKit
//
//  Created by ramon.pineda on 12/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation
import CoreData

class LoggingKitDAO : NSObject
{

    var context: NSManagedObjectContext?

    public override init()
    {
        super.init()
        context = LoggingKitCDManager().manageObjectContext
    }

    func save(request: RequestMO)
    {

        let loggingEntity = NSEntityDescription.insertNewObject(forEntityName: "LoggingKitMO", into: self.context!)
        
        loggingEntity.setValue(request.deviceID, forKey: "deviceID")
        loggingEntity.setValue(request.message, forKey: "message")
        loggingEntity.setValue(request.headerString, forKey: "headerString")
        loggingEntity.setValue(request.loggingLevel?.description(), forKey: "loggingLevel")
        loggingEntity.setValue(request.requestBodyString, forKey: "requestBodyString")
        loggingEntity.setValue(request.responseBodyString, forKey: "responseBodyString")
        loggingEntity.setValue(request.serviceURL, forKey: "serviceURL")
        loggingEntity.setValue(request.timestamp, forKey: "timestamp")

        /*let loggingEntity = NSEntityDescription.entity(forEntityName: "LoggingKitMO", in: self.context!)
        let loggingMO = LoggingKitNMO(entity: loggingEntity!, insertInto: self.context)
        let loggingMO = NSManagedObject(entity: loggingEntity!, insertInto: self.context!) as? LoggingKitMO
        loggingMO.deviceID = request.deviceID
        loggingMO.message = request.message
        loggingMO.headerString = request.headerString
        loggingMO.loggingLevel = request.loggingLevel
        loggingMO.requestBodyString = request.requestBodyString
        loggingMO.responseBodyString = request.responseBodyString
        loggingMO.serviceURL = request.serviceURL*/

        if (self.context?.hasChanges)!
        {
            do {
                try self.context?.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

    }
    
    func fetchAll() -> [RequestMO]
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoggingKitMO")
        let sortDescriptor = NSSortDescriptor(key: "deviceID", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        var requests = [RequestMO]()
        do
        {
            let result = try self.context?.fetch(fetchRequest)
            for managedObject in result!
            {
                requests.append(self.toRequestMO(req: managedObject as! NSManagedObject))
            }
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        return requests
    }

    func fetchEarlierThan(date: Date) -> [RequestMO]
    {
        var requests = [RequestMO]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoggingKitMO")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "timestamp <= %@", date as NSDate)
        fetchRequest.predicate = predicate
        do
        {
            let result = try self.context?.fetch(fetchRequest)
            for managedObject in result!
            {
                requests.append(self.toRequestMO(req: managedObject as! NSManagedObject))
            }
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        return requests
    }
    
    func fetchLaterThan(date: Date) -> [RequestMO]
    {
        var requests = [RequestMO]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoggingKitMO")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "timestamp >= %@", date as NSDate)
        fetchRequest.predicate = predicate
        do
        {
            let result = try self.context?.fetch(fetchRequest)
            for managedObject in result!
            {
                requests.append(self.toRequestMO(req: managedObject as! NSManagedObject))
            }
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        return requests
    }
    
    func fetchBetweenDates(date1: Date, date2: Date) -> [RequestMO]
    {
        var requests = [RequestMO]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoggingKitMO")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp <= %@", date1 as NSDate, date2 as NSDate)
        fetchRequest.predicate = predicate
        do
        {
            let result = try self.context?.fetch(fetchRequest)
            for managedObject in result!
            {
                requests.append(self.toRequestMO(req: managedObject as! NSManagedObject))
            }
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        return requests
    }
    
    func fetchByString(string: NSString) -> [RequestMO]
    {
        var requests = [RequestMO]()
        let pattern = "message LIKE %@ OR headerString LIKE %@ OR requestBodyString LIKE %@ OR responseBodyString LIKE %@ OR serviceURL LIKE %@"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoggingKitMO")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: pattern, "*\(string)*", "*\(string)*", "*\(string)*", "*\(string)*", "*\(string)*")
        fetchRequest.predicate = predicate
        do
        {
            let result = try self.context?.fetch(fetchRequest)
            for managedObject in result!
            {
                requests.append(self.toRequestMO(req: managedObject as! NSManagedObject))
            }
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        return requests
    }
    
    func fetchByLoggingLevel(level: LoggingLevel) -> [RequestMO]
    {
        var requests = [RequestMO]()
        let pattern = "loggingLevel == %@"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoggingKitMO")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: pattern, level.description())
        fetchRequest.predicate = predicate
        do
        {
            let result = try self.context?.fetch(fetchRequest)
            for managedObject in result!
            {
                requests.append(self.toRequestMO(req: managedObject as! NSManagedObject))
            }
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        return requests
    }

    func toLoggingKitMO(req: NSManagedObject) -> LoggingKitMO
    {
        let loggingKitMO = LoggingKitMO()
        loggingKitMO.deviceID = req.value(forKey: "deviceID") as! String?
        loggingKitMO.message = req.value(forKey: "message") as! String?
        loggingKitMO.headerString = req.value(forKey: "headerString") as! String?
        loggingKitMO.loggingLevel = req.value(forKey: "loggingLevel") as! String?
        loggingKitMO.requestBodyString = req.value(forKey: "requestBodyString") as! String?
        loggingKitMO.responseBodyString = req.value(forKey: "responseBodyString") as! String?
        loggingKitMO.serviceURL = req.value(forKey: "serviceURL") as! String?
        loggingKitMO.timestamp = req.value(forKey: "timestamp") as! NSDate?
        return loggingKitMO
    }
    
    func toRequestMO(req: NSManagedObject) -> RequestMO
    {
        let requestMO = RequestMO()
        requestMO.deviceID = req.value(forKey: "deviceID") as! String?
        requestMO.message = req.value(forKey: "message") as! String?
        requestMO.headerString = req.value(forKey: "headerString") as! String?
        requestMO.loggingLevel = LoggingLevel.toEnum(description: (req.value(forKey: "loggingLevel") as! String?)!) //String to Enum
        requestMO.requestBodyString = req.value(forKey: "requestBodyString") as! String?
        requestMO.responseBodyString = req.value(forKey: "responseBodyString") as! String?
        requestMO.serviceURL = req.value(forKey: "serviceURL") as! String?
        requestMO.timestamp = req.value(forKey: "timestamp") as! NSDate?
        return requestMO
    }

}
