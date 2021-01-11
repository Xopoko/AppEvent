//
//  Broadcast.swift
//  AppEvent
//
//  Created by Максим Кудрявцев on 11.01.2021.
//

import Foundation

class Broadcasting: AppEventBroadcastingType {
    private var whenArray: [(appEvent: AppEventType, closure: (() -> Void)?)] = []
    
    func when(_ appEvent: AppEventType, _ closure: @escaping () -> Void) {
        whenArray.append((appEvent, closure))
    }
    
    func broadcast(for appEvent: AppEventType) {
        for when in whenArray where when.appEvent.isEqual(to: appEvent) {
            when.closure?()
        }
    }
}
