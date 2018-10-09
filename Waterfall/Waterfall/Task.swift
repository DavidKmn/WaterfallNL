//
//  Task.swift
//  Waterfall
//
//  Created by David on 16/06/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

protocol Task {
    var isRunning: Bool { get }
    var isCancelled: Bool { get }
    func start()
    func resume()
    func cancel()
}

extension URLSessionTask: Task {
    var isRunning: Bool {
        return state == .running
    }
    
    var isCancelled: Bool {
        return !isRunning
    }
    
    func start() {
        self.resume()
    }
}
