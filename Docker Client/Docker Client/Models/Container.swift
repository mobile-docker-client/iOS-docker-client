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

class Container {
    var id: String
    var names: [String]
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
    
    func start() {
        DataManager.shared.startContainerWith(id)
    }
    
    func stop() {
        DataManager.shared.stopContainerWith(id)
    }
    
    func pause() {
        DataManager.shared.pauseContainerWith(id)
    }
    
    func restart() {
        DataManager.shared.restartContainerWith(id)
    }
    
    func set(state: ContainerState) {
        self.state = state
    }
}
