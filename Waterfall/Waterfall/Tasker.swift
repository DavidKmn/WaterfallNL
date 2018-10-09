//
//  Tasker.swift
//  Waterfall
//
//  Created by David on 16/06/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

// Protocol to define Jobs
protocol Tasker: class {
    typealias JobType = (TaskResult) throws -> Task
    
    /// Adds a task to to be executed.
    ///
    /// - parameter job: The function to execute.
    func add(job: @escaping JobType)
    
    /// Adds all tasks to be executed.
    ///
    /// - parameter jobs: The list of functions to execute.
    func add(jobs: [JobType])
}


