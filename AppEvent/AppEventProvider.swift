//
//  AppEventProvider.swift
//  AppEvent
//
//  Created by Horoko on 27.12.2020.
//  Copyright © 2020 Horoko. All rights reserved.
//

//TODO: Настройки с количесвом сохраняемых лог файлов

public class AppEventProvider<AppEvent: AppEventType> {
    var currentLogFilePath = ""
    var allLogFilePaths: [String] = []
    
    private let logFilesCount: Int
    private let dateFormat   : String
    private let logFileName  : String
    private let plugins      : [AppEventPluginType]
    private var fileHandle   : FileHandle?
    private var whenArray    : [(appEvent: AppEvent, closure: (() -> Void)?)] = []
    
    /// - parameter logFilesCount: Count of stored log files besides current. Default value is = `2`.
    /// - parameter dateFormat   : Date format using in log file and log file name. Default value is = `dd.MM.yyy-HH.mm.ss.SSS`.
    /// - parameter logFileName  : Log file name after `dateFormat` prefix. Default value is = `log.txt`
    /// - parameter plugins      : Array of plugins protocol `AppEventPluginType`. Default value is = `[]`
    init(logFilesCount: Int  = 2,
         dateFormat: String  = "dd.MM.yyy-HH.mm.ss.SSS",
         logFileName: String = "log.txt",
         plugins: [AppEventPluginType] = []) {
        self.logFilesCount = logFilesCount
        self.dateFormat    = dateFormat
        self.logFileName   = logFileName
        self.plugins       = plugins
        
        fileHandle = buildFileHandle()
        startHandleCrash()
        clearOldLogFiles()
        allLogFilePaths = getAllLogFiles()
    }
    
    func happened(_ appEvent: AppEvent, _ fileName: String = #file, _ functionName: String = #function, _ lineNumber: UInt = #line) {
        plugins.forEach { $0.willHappened(appEvent) }
        
        let printString = buildPrintString(appEvent, fileName, functionName, lineNumber)
        
        if appEvent.shouldPrint {
            print(printString)
        }
        if appEvent.shouldWriteToLog {
            write(printString)
        }
        
        if appEvent.shouldBroadcast {
            for when in whenArray where when.appEvent.isEqual(to: appEvent) {
                when.closure?()
            }
        }
        
        plugins.forEach { $0.didHappened(appEvent) }
    }
    
    func when(_ appEvent: AppEvent, _ closure: @escaping () -> Void) {
        whenArray.append((appEvent, closure))
    }
}

private extension AppEventProvider {
    func write(_ string: String) {
        fileHandle?.seekToEndOfFile()
        if let dataToWrite = string.data(using: String.Encoding.utf8) {
            fileHandle?.write(dataToWrite)
        }
    }
    
    func buildFileHandle() -> FileHandle? {
        let logsDirectoryPath = NSHomeDirectory() + "/Documents/Logs/"
        currentLogFilePath = logsDirectoryPath + formattedDateString(dateFormat) + "-" + logFileName
        if !FileManager.default.fileExists(atPath: currentLogFilePath) {
            FileManager.default.createFile(atPath: currentLogFilePath, contents: nil, attributes: nil)
        }
        return FileHandle(forWritingAtPath: currentLogFilePath)
    }
    
    func formattedDateString(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: Date())
    }
    
    func buildPrintString(_ appEvent: AppEvent, _ fileName: String, _ functionName: String, _ lineNumber: UInt) -> String {
        let message = appEvent.message == nil ? "" : " ⇨ \(appEvent.message!)"
        let filenameWithoutPath = fileName.contains("/") ? String(fileName.split(separator: "/").last!) : fileName
        let printString = "\(appEvent.logLevel) ⇨ \(formattedDateString(dateFormat)) ⇨ \(filenameWithoutPath) ⇨ \(functionName) ⇨ \(lineNumber)\(message)"
        return printString
    }
    
    func startHandleCrash() {
        NSSetUncaughtExceptionHandler { exception in
           let stack = exception.callStackReturnAddresses
           // TODO:
        }
    }
    
    func clearOldLogFiles() {
        guard let content = try? FileManager.default.contentsOfDirectory(atURL: URL(fileURLWithPath: NSHomeDirectory() + "/Documents/Logs/")) else { return }
        let pathsToDelete = content[logFilesCount - 1..<content.count]
        pathsToDelete.forEach { try? FileManager.default.removeItem(at: URL(fileURLWithPath: $0)) }
    }
    
    func getAllLogFiles() -> [String] {
        return (try? FileManager.default.contentsOfDirectory(atURL: URL(fileURLWithPath: NSHomeDirectory() + "/Documents/Logs/"))) ?? []
    }
}


public extension FileManager {
    func contentsOfDirectory(atURL url: URL, ascending: Bool = true, options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]) throws -> [String]? {
        var files = try contentsOfDirectory(at: url, includingPropertiesForKeys: [.creationDateKey], options: options)
        try files.sort {
            let values1 = try $0.resourceValues(forKeys: [.creationDateKey])
            let values2 = try $1.resourceValues(forKeys: [.creationDateKey])
            if let date1 = values1.allValues.first?.value as? Date, let date2 = values2.allValues.first?.value as? Date {
                return date1.compare(date2) == (ascending ? .orderedAscending : .orderedDescending)
            }
            return true
        }
        return files.map { $0.lastPathComponent }
    }
}
