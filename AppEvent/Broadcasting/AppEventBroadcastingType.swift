//
//  AppEventBroadcastingType.swift
//  AppEvent
//
//  Created by Максим Кудрявцев on 11.01.2021.
//

public protocol AppEventBroadcastingType {
    func when(_ appEvent: AppEventType, _ closure: @escaping () -> Void)
    func broadcast(for appEvent: AppEventType)
}
