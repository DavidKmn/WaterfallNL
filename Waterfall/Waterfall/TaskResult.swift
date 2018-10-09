//
//  TaskResult.swift
//  Waterfall
//
//  Created by David on 16/06/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

// Structure to aid handshake between Jobs
struct TaskResult {
    
    /// A block to define handshake from previous and next function
    typealias ContinueWithResultsType = (Result<Any>) -> Void
    
    /// The waterfall/parallel/other object associated with the result
    var currentTask: Task?
    
    /// The data object of the previous function
    var userInfo: Any?
    
    /// This is executed to let the waterfalle know it has finished its task
    var continueWithResults: ContinueWithResultsType
    
    init(currentTask: Task?, userInfo: Any?, continueWithResults: @escaping ContinueWithResultsType) {
        self.currentTask = currentTask
        self.userInfo = userInfo
        self.continueWithResults = continueWithResults
    }
}
