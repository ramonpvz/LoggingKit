//
//  LoggingKitUtils.swift
//  LoggingKit
//
//  Created by ramon.pineda on 2/10/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class LoggingKitUtils: NSObject {

    static var midnight: Date = {
        let currentComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var dateComponent = DateComponents()
        dateComponent.year = currentComponents.year!
        dateComponent.month = currentComponents.month!
        dateComponent.day = currentComponents.day!
        dateComponent.timeZone = TimeZone(abbreviation: "UTC")
        dateComponent.hour = 0
        dateComponent.minute = 0
        return Calendar.current.date(from: dateComponent)!
    }()

    static var dayBeforeYesterday: Date = {
        let currComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var dateComponents = DateComponents()
        dateComponents.year = currComponents.year!
        dateComponents.month = currComponents.month!
        dateComponents.day = (currComponents.day! - 2)
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.hour = 0
        dateComponents.minute = 0
        return Calendar.current.date(from: dateComponents)!
    }()

}
