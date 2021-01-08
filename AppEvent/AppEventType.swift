//
//  AppEventType.swift
//  AppEvent
//
//  Created by Horoko on 27.12.2020.
//  Copyright © 2020 Horoko. All rights reserved.
//
public protocol AppEventType {
    var message         : String? { get }
    var logLevel        : String  { get }
    var shouldPrint     : Bool    { get }
    var shouldWriteToLog: Bool    { get }
    var shouldBroadcast : Bool    { get }
    
    func isEqual(to appEventType: AppEventType) -> Bool
}

public extension AppEventType where Self: Equatable {
    func isEqual(to appEventType: AppEventType) -> Bool {
        return (appEventType as? Self).flatMap({ $0 == self }) ?? false
    }
}
