//
//  RequestMO.swift
//  LoggingKit
//
//  Created by ramon.pineda on 1/28/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation

public enum LoggingLevel: String
{

    case DEBUG, ERROR, FATAL, INFO, WARNING
    static let kDebugLvl = "DEBUG"
    static let kErrorLvl = "ERROR"
    static let kFatalLvl = "FATAL"
    static let kInfoLvl = "INFO"
    static let kWarningLvl = "WARNING"
    
    public func description() -> String
    {
        switch self
        {
            case .DEBUG: return LoggingLevel.kDebugLvl
            case .ERROR: return LoggingLevel.kErrorLvl
            case .FATAL: return LoggingLevel.kFatalLvl
            case .INFO: return LoggingLevel.kInfoLvl
            case .WARNING: return LoggingLevel.kWarningLvl
        }
    }
    
    public static func toEnum(description: String) -> LoggingLevel
    {
        if description == LoggingLevel.kDebugLvl { return .DEBUG }
        else if description == LoggingLevel.kErrorLvl { return .ERROR }
        else if description == LoggingLevel.kInfoLvl { return .INFO }
        else if description == LoggingLevel.kWarningLvl { return .WARNING }
        else { return .FATAL }
    }

}

public class RequestMO : NSObject
{

    public var deviceID: String?
    public var message: String?
    public var headerString: String?
    public var loggingLevel: LoggingLevel?
    public var requestBodyString: String?
    public var responseBodyString: String?
    public var serviceURL: String?
    public var timestamp: NSDate?
    
    lazy var loggingLevelString:String? = {
        return self.loggingLevel?.description()
    }()
    
    public override init()
    {
        super.init();
        self.timestamp = NSDate()
    }

    public func save()
    {
        LoggingKitDAO().save(request: self);
    }
    
    public func fetchAll() -> [RequestMO]
    {
        return LoggingKitDAO().fetchAll();
    }

    public func fetchAllBeforeMidnight() -> [RequestMO]
    {
        return LoggingKitDAO().fetchEarlierThan(date:LoggingKitUtils.midnight)
    }
    
    public func fetchAllAfterMidnight() -> [RequestMO]
    {
        return LoggingKitDAO().fetchLaterThan(date:LoggingKitUtils.midnight)
    }
    
    public func fetchAllBetweenDates(date1: Date, date2: Date) -> [RequestMO]
    {
        return LoggingKitDAO().fetchBetweenDates(date1: date1, date2: date2);
    }

    public func fetchAllByString(pattern: NSString) -> [RequestMO]
    {
        return LoggingKitDAO().fetchByString(string: pattern)
    }

    public func fetchAllByLoggingLevel(level: LoggingLevel) -> [RequestMO]
    {
        return LoggingKitDAO().fetchByLoggingLevel(level: level);
    }

}
