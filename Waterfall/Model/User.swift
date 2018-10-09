//
//  User.swift
//  Waterfall
//
//  Created by David on 16/06/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
//{
//    id: 1,
//    name: "Leanne Graham",
//    username: "Bret",
//    email: "Sincere@april.biz",
//    address: {
//        street: "Kulas Light",
//        suite: "Apt. 556",
//        city: "Gwenborough",
//        zipcode: "92998-3874",
//        geo: {
//            lat: "-37.3159",
//            lng: "81.1496"
//        }
//    },

struct User {
    let id: Int
    let name: String?
    let username: String?
    let email: String?
    let address: Address
}

extension User: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, name, username, email, address
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        address = try container.decode(Address.self, forKey: .address)
    }
}

struct Address {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
}

extension Address: Decodable {
    private enum CodingKeys: String, CodingKey {
        case street, suite, city, zipcode
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        street = try container.decode(String.self, forKey: .street)
        suite = try container.decode(String.self, forKey: .suite)
        city = try container.decode(String.self, forKey: .city)
        zipcode = try container.decode(String.self, forKey: .zipcode)
    }
}
