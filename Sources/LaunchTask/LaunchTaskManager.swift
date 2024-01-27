//
//  LaunchTaskManager.swift
//  XianWen
//
//  Created by Songming on 2023/5/8.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if os(iOS)
public typealias LaunchOptionsKey = UIApplication.LaunchOptionsKey
#elseif os(macOS)
public typealias LaunchOptionsKey = String
#endif

public protocol LaunchTask: AnyObject {
    
    var status: LaunchTaskStatus { get set }
    
    func onLaunch(options: [LaunchOptionsKey: Any]?) async -> Bool
    
}

public enum LaunchTaskStatus {
    case none
    case executing
    case succeed
    case failed
}

public class LaunchTaskManager {
    
    public static let shared = LaunchTaskManager()
    
    public private (set) var launchTasks: [any LaunchTask] = []
    
    public func register(task: LaunchTask) {
        task.status = .none
        launchTasks.append(task)
    }
    
    public func launch(options: [LaunchOptionsKey : Any]?) async {
        await withTaskGroup(of: Bool.self) { group in
            launchTasks.forEach { task in
                group.addTask {
                    return await self.execute(task: task, options: options)
                }
            }
        }
    }
    
    public func retry() async {
        await withTaskGroup(of: Bool.self) { group in
            launchTasks.filter {
                $0.status == .failed
            }.forEach { task in
                group.addTask {
                    return await self.execute(task: task)
                }
            }
        }
    }
    
    func execute(task: LaunchTask, options: [LaunchOptionsKey: Any]? = nil) async -> Bool {
        task.status = .executing
        let suc = await task.onLaunch(options: options)
        if suc {
            task.status = .succeed
        } else {
            task.status = .failed
        }
        return suc
    }
}
