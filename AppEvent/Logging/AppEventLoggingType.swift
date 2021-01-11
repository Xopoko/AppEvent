//
//  AppEventLoggingType.swift
//  AppEvent
//
//  Created by Максим Кудрявцев on 11.01.2021.
//

public protocol AppEventLoggingType {
    var currentLogFilePath: String   { get }
    var allLogFilePaths   : [String] { get }
    
    func write(_ appEvent: AppEventType, _ fileName: String, _ functionName: String, _ lineNumber: UInt)
}
