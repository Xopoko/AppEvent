//
//  AppEventPluginType.swift
//  AppEvent
//
//  Created by Horoko on 28.12.2020.
//  Copyright © 2020 Horoko. All rights reserved.
//

public protocol AppEventPluginType {
    func willHappened(_ appEvent: AppEventType)
    func didHappened (_ appEvent: AppEventType)
}

public extension AppEventPluginType {
    func willHappened(_ appEvent: AppEventType) {}
    func didHappened (_ appEvent: AppEventType) {}
}
