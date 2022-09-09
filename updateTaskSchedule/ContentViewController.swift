//
//  ContentViewController.swift
//  updateTaskSchedule
//
//  Created by Bo Zhang on 9/9/22.
//

import UIKit
import CareKit
import CareKitStore
import CareKitUI

class ContentViewController: OCKDailyPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(updateSchedule))
    }
    
    @objc func updateSchedule() {
        Task {
            // Find the existing task
            var task: OCKTask
            
            do {
                task = try await storeManager.store.fetchAnyTask(withID: "Medicine") as! OCKTask
            } catch {
                print("failed to fetch up")
                return
            }
            
            // Create new schedule
            let oldStartDate = Calendar.current.startOfDay(for: Date())
            
            let newStartDate = Calendar.current.date(
                byAdding: .day, value: 4, to: oldStartDate
            )!
            let newScheduleElement = OCKScheduleElement(
                start: newStartDate,
                end: nil,
                interval: DateComponents(day: 2),
                text: nil,
                targetValues: [],
                duration: .allDay
            )
            let newSchedule = OCKSchedule(composing: [newScheduleElement])
            
            // Update task
            task.schedule = newSchedule
            task.effectiveDate = newStartDate
            
            // Save
            storeManager.store.updateAnyTask(task,
                                             callbackQueue: .main) { result in
                switch result {
                case let .success(task):
                    print("updated \(task.uuid), \(task.id), \(task.schedule)")
                    
                case let .failure(error):
                    print("Failed to update task: \(error as NSError)")
                }
            }
        }
    }
        
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController, prepare listViewController: OCKListViewController, for date: Date) {
        Task {
            let tasks = await fetchTasks(on: date)
            
            tasks.compactMap {
                let card = self.taskViewController(for: $0, on: date)
                return card
            }.forEach {
                listViewController.appendViewController($0, animated: false)
            }
        }
    }
    
    private func fetchTasks(on date: Date) async -> [OCKAnyTask] {
        var query = OCKTaskQuery(for: date)
        query.excludesTasksWithNoEvents = true
        
        do {
            let tasks = try await storeManager.store.fetchAnyTasks(query: query)
            return tasks
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
            return []
        }
    }
    
    private func taskViewController(for task: OCKAnyTask, on date: Date) -> UIViewController? {
        switch task.id {
        case "Medicine":
            return OCKSimpleTaskViewController(task: task, eventQuery: .init(for: date), storeManager: self.storeManager)
            
        default:
            return nil
        } 
    }
    
}
