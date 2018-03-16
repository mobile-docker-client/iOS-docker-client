//
//  Container.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 16.03.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

enum ContainerStatus {
    case run
    case pause
    case stop
}

class Container {
    var id: String
    var name: String
    var status: ContainerStatus
    
    init(id: String, status: ContainerStatus, name: String) {
        self.id = id
        self.status = status
        self.name = name
    }
    
    func set(status: ContainerStatus) {
        self.status = status
    }
}
