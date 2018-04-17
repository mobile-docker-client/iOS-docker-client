//
//  Container.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 16.03.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import Foundation

enum ContainerStatus {
    case run
    case pause
    case stop
}

class Container {
    var id: String
    var names: [String]
    var created: Date
//    var created: Data
//    var status: ContainerStatus
//    var statusDescription: String
//    var config: JSON
    
//    init(id: String, status: ContainerStatus, statusDescription: String, name: String) {
//        self.id = id
//        self.status = status
//        self.name = name
//        self.statusDescription = statusDescription
//    }
    
    init(id: String, names: [String], created: Date) {
        self.id = id
        self.names = names
        self.created = created
    }
    
//    func set(status: ContainerStatus) {
//        self.status = status
//    }
}
