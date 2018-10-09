//
//  APIManager.swift
//  Waterfall
//
//  Created by David on 16/06/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class APIManager<T: Decodable> {
    
    enum JSONNetworkServiceError: Error {
        case failedToSendRequest
        case invalidUserInfo(result: Any?, expected: Any.Type)
        case noData
        case failedToParseData
    }
    
    typealias CompletionBlock = (Result<T>) -> (Void)
    
    func fetchData(atUrl urlString: String, completion: @escaping CompletionBlock) -> Task {
        
        let waterfallTask = Waterfall(with: urlString, completionBlock: completion)
        
        waterfallTask.add(jobs: [
            self.makeGetRequest(),
            self.perfomrNetworkRequestTask(),
            self.parseResponse()
            ])
        
        return waterfallTask
    }
    
    private func makeGetRequest() -> Tasker.JobType {
        return Job.throwableTask(withThrowableBlock: { (result) -> Any in
            
            guard let urlPath = result.userInfo as? String, let url = URL(string: urlPath) else {
                throw JSONNetworkServiceError.failedToSendRequest
            }
            
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            
            return request
        })
    }
    
    
    private func perfomrNetworkRequestTask(usingSession session: URLSession = .shared) -> Tasker.JobType {
        
        return { result in
            
            guard let urlRequest = result.userInfo as? URLRequest else {
                throw JSONNetworkServiceError.failedToSendRequest
            }
            
            return session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                switch (data, response, error) {
                case (.some(let responseData), _, _):
                    result.continueWithResults(.Success(responseData))
                case (_, _, .some(let requestError)):
                    result.continueWithResults(.Failure(requestError))
                default:
                    result.continueWithResults(.Failure(JSONNetworkServiceError.noData))
                }
            })
        }
    }
    
    private func parseResponse() -> Tasker.JobType {
        return Job.throwableTask(withThrowableBlock: { (result) -> Any in
            
            guard let requestResponseData = result.userInfo as? Data else {
                throw JSONNetworkServiceError.failedToParseData
            }
            
            return try JSONDecoder().decode(T.self, from: requestResponseData)
        })
    }
    
}
