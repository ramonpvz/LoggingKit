//
//  LoggingKitTests.swift
//  LoggingKitTests
//
//  Created by ramon.pineda on 12/23/16.
//  Copyright © 2016 Home. All rights reserved.
//

import XCTest
import CoreData

class LoggingKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample()
    {
        //self.save()
        //self.fetchAll()
        //self.fetchAllBeforeMidnight()
        //self.fetchAllAfterMidnight()
        //self.fetchAllByString(pattern: "kiosko")
        //self.fetchAllBetweenDates()
        //self.fetchAllByLoggingLevel(level: LoggingLevel.FATAL)
    }

    func save()
    {
        let requestMO = RequestMO()
        requestMO.deviceID = "12345678"
        requestMO.message = "test message"
        requestMO.headerString = "test header"
        requestMO.loggingLevel = LoggingLevel.ERROR
        requestMO.requestBodyString = "test request string"
        requestMO.responseBodyString = "test response string"
        requestMO.serviceURL = "http://www.google.com"
        requestMO.save();
    }

    func fetchAll()
    {
        for req in RequestMO().fetchAll()
        {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
            self.printRequestMO(requestMO: req)
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        }
    }
    
    func fetchAllBeforeMidnight()
    {
        for req in RequestMO().fetchAllBeforeMidnight()
        {
            print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
            self.printRequestMO(requestMO: req)
            print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
        }
    }
    
    func fetchAllAfterMidnight()
    {
        for req in RequestMO().fetchAllAfterMidnight()
        {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
            self.printRequestMO(requestMO: req)
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        }
    }
    
    func fetchAllBetweenDates()
    {
        let today = Date()
        for req in RequestMO().fetchAllBetweenDates(date1: LoggingKitUtils.dayBeforeYesterday, date2: today)
        {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
            self.printRequestMO(requestMO: req)
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        }
    }
    
    func fetchAllByString(pattern: NSString)
    {
        for req in RequestMO().fetchAllByString(pattern: pattern)
        {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
            self.printRequestMO(requestMO: req)
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        }
    }

    func fetchAllByLoggingLevel(level: LoggingLevel)
    {
        for req in RequestMO().fetchAllByLoggingLevel(level: level)
        {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
            self.printRequestMO(requestMO: req)
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        }
    }

    func printRequestMO(requestMO: RequestMO)
    {
        print(requestMO.deviceID!)
        print(requestMO.message!)
        print(requestMO.headerString!)
        print(requestMO.loggingLevel?.description() ?? "Nil")
        print(requestMO.requestBodyString!)
        print(requestMO.responseBodyString!)
        print(requestMO.serviceURL!)
        print(requestMO.timestamp ?? "Nil")
    }

}
