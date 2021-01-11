//
//  AppEventProvider.swift
//  AppEvent
//
//  Created by Horoko on 27.12.2020.
//  Copyright © 2020 Horoko. All rights reserved.
//

//TODO: Настройки с количесвом сохраняемых лог файлов

public class AppEventProvider<AppEvent: AppEventType> {
    public var currentLogFilePath: String   { logging.currentLogFilePath }
    public var allLogFilePaths   : [String] { logging.allLogFilePaths    }
    
    private let logging     : AppEventLoggingType
    private let printing    : AppEventPrintingType
    private let broadcasting: AppEventBroadcastingType
    
    private var logFilesCount = 2
    private var dateFormat    = "dd.MM.yyy-HH.mm.ss.SSS"
    private var logFileName   = "log.txt"
    private var plugins       = [AppEventPluginType]()
    
    public init(options: Option...,
                loggingType: AppEventLoggingType? = nil,
                printingType: AppEventPrintingType? = nil,
                broadcastingType: AppEventBroadcastingType? = nil) {
        for option in options {
            switch option {
            case let .logFilesCount(logFilesCount): self.logFilesCount = logFilesCount
            case let .dateFormat   (dateFormat)   : self.dateFormat    = dateFormat
            case let .logFileName  (logFileName)  : self.logFileName   = logFileName
            case let .plugins      (plugins)      : self.plugins       = plugins
            }
        }
        
        if let loggingType = loggingType {
            self.logging = loggingType
        } else {
            self.logging = Logging(dateFormat: dateFormat, logFilesCount: logFilesCount, logFileName: logFileName)
        }
        
        if let printingType = printingType {
            self.printing = printingType
        } else {
            self.printing = Printing(dateFormat: dateFormat)
        }
        
        if let broadcastingType = broadcastingType {
            self.broadcasting = broadcastingType
        } else {
            self.broadcasting = Broadcasting()
        }
    }
}

public extension AppEventProvider {
    func happened(_ appEvent: AppEvent, _ fileName: String = #file, _ functionName: String = #function, _ lineNumber: UInt = #line) {
        plugins.forEach { $0.willHappened(appEvent) }
        
        if appEvent.shouldPrint {
            printing.print(appEvent, fileName, functionName, lineNumber)
        }
        if appEvent.shouldWriteToLogFile {
            logging.write(appEvent, fileName, functionName, lineNumber)
        }
        if appEvent.shouldBroadcast {
            broadcasting.broadcast(for: appEvent)
        }

        plugins.forEach { $0.didHappened(appEvent) }
    }
    
    func when(_ appEvent: AppEventType, _ closure: @escaping () -> Void) {
        broadcasting.when(appEvent, closure)
    }
}

public extension AppEventProvider {
    /// - parameter logFilesCount: Count of stored log files besides current.       Default value is = `2`
    /// - parameter dateFormat   : Date format using in log file and log file name. Default value is = `"dd.MM.yyy-HH.mm.ss.SSS"`
    /// - parameter logFileName  : Log file name after `dateFormat` prefix.         Default value is = `"log.txt"`
    /// - parameter plugins      : Array of plugins protocol `AppEventPluginType`.  Default value is = `[]`
    enum Option {
        case logFilesCount(Int)
        case dateFormat   (String)
        case logFileName  (String)
        case plugins      ([AppEventPluginType])
    }
}
