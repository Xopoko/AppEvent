//
//  Printing.swift
//  AppEvent
//
//  Created by Максим Кудрявцев on 11.01.2021.
//

class Printing: AppEventPrintingType {
    private let dateFormat: String
    
    init(dateFormat: String) {
        self.dateFormat = dateFormat
    }
    
    func print(_ appEvent: AppEventType, _ fileName: String, _ functionName: String, _ lineNumber: UInt) {
        let printString = buildPrintString(appEvent, fileName, functionName, lineNumber)
        Swift.print(printString)
    }
}

private extension Printing {
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
}
