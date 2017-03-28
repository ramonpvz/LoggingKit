//
//  LoggingKitMO.swift
//  LoggingKit
//
//  Created by ramon.pineda on 1/27/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoggingKitMO: NSManagedObject {

    var deviceID: String?
    var message: String?
    var headerString: String?
    var loggingLevel: String?
    var requestBodyString: String?
    var responseBodyString: String?
    var serviceURL: String?
    var timestamp: NSDate?

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

}
