//
//  ViewController.swift
//  Waterfall
//
//  Created by David on 16/06/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiManager = APIManager<[User]>()
        let usersUrlString = "https://jsonplaceholder.typicode.com/users"
        let task = apiManager.fetchData(atUrl: usersUrlString) { (result) -> (Void) in
            switch result {
            case .Success(let users): users.forEach { print($0.name ?? "-") }
            case .Failure(let error): print(error.localizedDescription)
            }
        }
        
        task.start()
    }

}

