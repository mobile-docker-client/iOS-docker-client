//
//  Container.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 16.03.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import Foundation
import SwiftyJSON

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
    var id: String?
    var names: [String]?
    var firstName: String? {
        get {
            if names!.count > 0 {
                return names![0]
            }
            return nil
        }
    }
    var created: Date?
    var statusDescription: String?
    var state: ContainerState?
    
    init(_ data: JSON) {
        updateWith(data, isInitial: true)
    }
    
    func updateWith(_ data: JSON, isInitial: Bool = false) {
        if isInitial {
            self.id = data["Id"].stringValue
            self.state = self.getContainerStateFrom(data["State"].stringValue)
            self.statusDescription = data["Status"].stringValue
            self.names = data["Names"].arrayObject as! [String]
            self.created = Date.init(timeIntervalSince1970: TimeInterval(data["Created"].intValue))
        } else {
            self.state = self.getContainerStateFrom(data["state"]["status"].stringValue)
        }
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
        DataManager.shared.makeContainerActionWith(id!, action)
    }
    
    func set(state: ContainerState) {
        self.state = state
    }
}
