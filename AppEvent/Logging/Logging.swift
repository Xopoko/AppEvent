//
//  Logging.swift
//  AppEvent
//
//  Created by Максим Кудрявцев on 11.01.2021.
//

import Foundation

class Logging: AppEventLoggingType {
    var allLogFilePaths: [String] { getAllLogFiles() }
    var currentLogFilePath = ""
    
    private var fileHandle   : FileHandle?
    private let logFilesCount: Int
    private let dateFormat   : String
    private let logFileName  : String
    
    init(dateFormat: String, logFilesCount: Int, logFileName: String) {
        self.dateFormat    = dateFormat
        self.logFilesCount = logFilesCount
        self.logFileName   = logFileName
        
        clearOldLogFiles()
        //TODO: Move it
        startHandleCrash()
    }
    
    func write(_ appEvent: AppEventType, _ fileName: String, _ functionName: String, _ lineNumber: UInt) {
        let writeString = buildPrintString(appEvent, fileName, functionName, lineNumber)
        fileHandle?.seekToEndOfFile()
        if let dataToWrite = writeString.data(using: String.Encoding.utf8) {
            fileHandle?.write(dataToWrite)
        }
    }
}

private extension Logging {
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
    
    func buildPrintString(_ appEvent: AppEventType, _ fileName: String, _ functionName: String, _ lineNumber: UInt) -> String {
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
        guard let content = try? contentsOfDirectory(atURL: URL(fileURLWithPath: NSHomeDirectory() + "/Documents/Logs/")) else { return }
        let pathsToDelete = content[logFilesCount - 1..<content.count]
        pathsToDelete.forEach { try? FileManager.default.removeItem(at: URL(fileURLWithPath: $0)) }
    }
    
    func getAllLogFiles() -> [String] {
        return (try? contentsOfDirectory(atURL: URL(fileURLWithPath: NSHomeDirectory() + "/Documents/Logs/"))) ?? []
    }
    
    func contentsOfDirectory(atURL url: URL, ascending: Bool = true) throws -> [String]? {
        var files = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.creationDateKey], options: [.skipsHiddenFiles])
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
