//
//  AppDelegate.swift
//  updateTaskSchedule
//
//  Created by Bo Zhang on 9/9/22.
//

import Foundation
import UIKit
import CareKitStore
import CareKit

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    let storeManager = OCKSynchronizedStoreManager(
        wrapping: OCKStore(
            name: "debug",
            type: .inMemory
        )
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Add an all day task repeating for two days
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: DateComponents(day: 2, second: -1), to: startDate)
        let scheduleElement = OCKScheduleElement(
            start: startDate, end: endDate,
            interval: DateComponents(day: 1),
            text: nil,
            targetValues: [],
            duration: .allDay
        )
        let schedule = OCKSchedule(composing: [scheduleElement])
        let task = OCKTask(
            id: "Medicine",
            title: "Take pill",
            carePlanUUID: nil,
            schedule: schedule
        )
        
        storeManager.store.addAnyTask(task,
                                      callbackQueue: .main) { result in
            switch result {
            case let .success(task):
                print("added task \(task.id), \(task.uuid), \(task.schedule)")
            case let .failure(error):
                print("failed to add task: \(error as NSError)")
            }
        }
                
        return true
    }

}
