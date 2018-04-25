//
//  Person.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 17.04.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import Foundation

class Person {
    var _servers: [Server] = []
    var servers: [Server] {
        get {
            if let data = UserDefaults.standard.value(forKey: "user_servers") as? Data {
                let array = try? PropertyListDecoder().decode(Array<Server>.self, from: data)
                _servers = array ?? _servers
            }
            return _servers
        }
        
        set {
            _servers = newValue
            UserDefaults.standard.set(try? PropertyListEncoder().encode(_servers), forKey: "user_servers")
            UserDefaults.standard.synchronize()
        }
    }
    
    var containers: [Container]?
}
