//
//  Waterfall.swift
//  Waterfall
//
//  Created by David on 16/06/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class Waterfall<T>: Task {
    
    //********** HELPERS *********
    
    enum TaskError: Error {
        case NoResult
    }
    
    typealias JobType = Tasker.JobType
    
    typealias CompletionType = (Result<T>) -> Void
    
    //*****************************
    
    var isRunning: Bool = false
    
    var isCancelled: Bool = false
    
    private lazy var jobs: [JobType] = []
    
    private var currentJobTask: Task?
    
    private let userInfo: Any?
    
    private var completionBlock: CompletionType
    
    /// Initialise with a userInfo and completionBlock
    init(with userInfo: Any? = nil, completionBlock: @escaping CompletionType) {
        self.userInfo = userInfo
        self.completionBlock = completionBlock
    }
    
    //MARK: Task
    
    func start() {
        guard currentJobTask == nil else {
            assertionFailure("Waterfall is already executing, suspended or cancelled")
            return
        }
        
        isRunning = true
        
        continueBlock(userInfo)
    }
    
    func resume() {
        
        if let current = currentJobTask {
            current.resume()
        } else {
            start()
        }
    }
    
    func cancel() {
        isRunning = false
        isCancelled = true
        currentJobTask?.cancel()
    }
    
    
    
    private func continueBlock(_ userInfo: Any?)  {
        
        guard !(self.isCancelled) else {
            self.isRunning = false
            return
        }
        
        guard self.jobs.count > 0 else {
            self.finish(userInfo: userInfo)
            return
        }
        
        let result = TaskResult(currentTask: self, userInfo: userInfo) { [weak self] (currentTaskResult) in
            
            switch currentTaskResult {
            case .Success(let result): self?.continueBlock(result)
            case .Failure(let error): self?.finish(error: error)
            }
        }
        
        do {
            self.currentJobTask = try self.jobs.removeFirst()(result)
            self.currentJobTask?.resume()
        } catch let error {
            self.finish(error: error)
        }
    }
    
    private func finish(userInfo: Any? = nil, error: Error? = nil) {
        
        self.isRunning = false
        self.currentJobTask = nil
        
        switch (userInfo, error) {
        case (.some(let completionValue as T), _): completionBlock(.Success(completionValue))
        case (_, .some(let error)): completionBlock(.Failure(error))
        default: completionBlock(.Failure(TaskError.NoResult))
        }
    }
}

extension Waterfall: Tasker {
    
    /// Adds a single task to the waterfall to be executed.
    ///
    /// - parameter job: The function to execute.
    func add(job: @escaping Tasker.JobType) {
        self.jobs.append(job)
    }
    
    
    /// Adds all task to the waterfall to be executed.
    ///
    /// - parameter jobs: The list of functions to execute.
    func add(jobs: [Tasker.JobType]) {
        self.jobs.append(contentsOf: jobs)
    }
    
}
