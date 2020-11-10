//
//  Logger.swift
//  Common
//
//  Created by Jefferson Barbosa Puchalski on 05/04/19.
//  Copyright © 2020 Mainstream ME. All rights reserved.
//

import Foundation
import os.log
import os.signpost

/**
 Logger category enumeration, user in Logger methods.
 */
public enum LoggerCategory: String {
    // AWS category
    case AWSUnspectedLambda = "unspectedLambda"
    case viewCycle = "viewCycle"
    case coordinator = "coordinator"
    case viewController = "viewController"
    case view = "UIView"
    case networning = "networking"
    case application = "application"
}

/**
 Logger signe post  enumeration.
 */
public enum SignPostCategory: Int {
    // Lifecycle posts
    case viewDidLoad = 0
    case viewWillAppear = 1
    case viewDidAppear = 2
    case viewWillDisapear = 3
    case viewDidDisapear = 4
    // Init life
    case deinitialization = 5
    case initialization = 6
}

public class Logger {
    
    // MARK: - Class lifecycle
    // Initializing class
    init() {
        print("Initializing constructor \(#function)")
    }
    // Deinit class
    deinit {
        print("Denitializing constructor \(#function)")
    }
    
    // MARK: - Methods
    /**
     Log a debug mesage to given category.
     - Parameters:
        - message: A message to be logged.
        - category: LoggerCategory to be indentified throught console.
     */
    public func log(message: String, category: LoggerCategory) {
        os_log("%s", log: OSLog.applyCategory(category: category), type: .default, message)
    }
    
    /**
     Log a debug mesage to given category.
     - Parameters:
        - message: A message to be logged.
        - category: LoggerCategory to be indentified throught console.
     */
    public func logDebug(message: String, category: LoggerCategory) {
        os_log("%s", log: OSLog.applyCategory(category: category), type: .debug, message)
    }
    
    /**
     Log a debug mesage to given category.
     - Parameters:
        - message: A message to be logged.
        - category: LoggerCategory to be indentified throught console.
        - args: Variadic args to pass for fill formate debug string.
     */
    public func logDebug(message: String, category: LoggerCategory, args: Any?...) {
        os_log("%s", log: OSLog.applyCategory(category: category), type: .debug, message, args)
    }

    /**
     Log a error mesage to given category.
     - Parameters:
        - message: A message to be logged.
        - category: LoggerCategory to be indentified throught console.
     */
    public func logError(message: String, category: LoggerCategory) {
        os_log("%s", log: OSLog.applyCategory(category: category), type: .error, message)
    }
    
    /**
     Log a error mesage to given category.
     - Parameters:
        - message: A message to be logged.
        - category: LoggerCategory to be indentified throught console.
     */
    public func logFault(message: String, category: LoggerCategory) {
        os_log("%s", log: OSLog.applyCategory(category: category), type: .fault, message)
    }
    
    /**
     Start a os sign post log notify.
     */
    public func startSignPost(message: String, name: SignPostCategory) {
        let osLog = OSLog.applyCategory(category: .application)
        os_signpost(.begin, log: osLog, name: toSignPostName(for: name))
    }
    
    /**
     Finish a os sign post log notify.
     */
    public func finishSignPost(message: String, name: SignPostCategory) {
        let osLog = OSLog.applyCategory(category: .application)
        os_signpost(.end, log: osLog, name: toSignPostName(for: name))
    }
    
    /**
     Transform the sign post category enum to a static string.
     */
    private func toSignPostName(for post: SignPostCategory) -> StaticString {
        switch post {
        case .viewWillAppear:
            return "viewWillAppear"
        case .viewDidAppear:
            return "viewDidAppear"
        case .viewDidLoad:
            return "viewDidLoad"
        case .viewWillDisapear:
            return "viewWillDisapear"
        case .viewDidDisapear:
            return "viewDidDisapear"
        case .deinitialization:
            return "DeInit"
        case .initialization:
            return "Init"
        }
    }
    
    // MARK: - Singleton
    private static var _logger = Logger()
    /**
     Get shared instance from Logger
     - Returns: A instance from Logger.
     */
    public class var shared: Logger {
        return _logger
    }
}

// MARK: - Extensions
extension OSLog {
    /// Get the subsystem from main indenfifier bundle.
    private static var subsystem = Bundle.main.bundleIdentifier!
    /**
     Create a new OSLog with given category.
     - Parameters:
        - category: The new category applied on OSLog.
     */
    static func applyCategory(category: LoggerCategory) -> OSLog {
        return OSLog(subsystem: subsystem, category: category.rawValue)
    }
}
