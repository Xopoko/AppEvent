//
//  AppEventPrintingType.swift
//  AppEvent
//
//  Created by Максим Кудрявцев on 11.01.2021.
//

public protocol AppEventPrintingType {
    func print(_ appEvent: AppEventType, _ fileName: String, _ functionName: String, _ lineNumber: UInt)
}
