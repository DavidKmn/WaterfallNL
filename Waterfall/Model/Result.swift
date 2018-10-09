//
//  Result.swift
//  Waterfall
//
//  Created by David on 16/06/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

enum Result<Value> {
    case Success(Value)
    case Failure(Error)
}

extension Result {
    /// Evaluates the given closure when this Result is `.success`, passing the
    /// unwrapped value as a parameter.
    ///
    /// - Parameter transform: A closure that takes the unwrapped success value.
    /// - Returns: The result of the given closure. If the instance is `failure`
    
    func map<T>(transform: (Value) -> T) -> Result<T> {
        switch self {
        case .Success(let value):
            return .Success(transform(value))
        case .Failure(let error):
            return .Failure(error)
        }
    }
    
    /// Evaluates the given closure when this Result is `.success`, passing the
    /// unwrapped value as a parameter.
    ///
    /// - Parameter transform: A closure that takes the unwrapped success value.
    /// - Returns: The result of the given closure. If the instance is `failure`
    ///   returns the failure.
    public func flatMap<T>(transform: (Value) -> Result<T>) -> Result<T> {
        switch self {
        case .Success(let value):
            return transform(value)
        case .Failure(let error):
            return .Failure(error)
        }
    }
}
