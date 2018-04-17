//
//  Container.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 16.03.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import Foundation

enum ContainerState {
    case running
    case paused
    case stopped
    case exited
}

enum ContainerAction: String {
    case start = "start"
    case stop = "stop"
    case pause = "pause"
    case restart = "restart"
}

class Container {
    var id: String
    var names: [String]
    var firstName: String? {
        get {
            if names.count > 0 {
                return names[0]
            }
            return nil
        }
    }
    var created: Date
    var statusDescription: String
    var state: ContainerState = .exited
    
    init(id: String, names: [String], created: Date, state: String, statusDescription: String) {
        self.id = id
        self.names = names
        self.created = created
        self.statusDescription = statusDescription
        self.state = self.getContainerStateFrom(state)
    }
    
    private func getContainerStateFrom(_ state: String) -> ContainerState {
        switch state {
        case "exited":
            return .exited
        case "running":
            return .running
        case "paused":
            return .paused
        case "stopped":
            return .stopped
        default:
            return .exited
        }
    }
    
    func make(action: ContainerAction) {
        DataManager.shared.makeContainerActionWith(id, action)
    }
    
    func set(state: ContainerState) {
        self.state = state
    }
}
