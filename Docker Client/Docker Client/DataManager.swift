//
//  DataManager.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 17.04.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol DataManagerDelegate {
    func allContainersUpdate()
    func resultOfContainerActionWith(_ id: String, _ action: ContainerAction, isError: Bool)
    func updateContainerWith(_ id: String, data: JSON)
}

class DataManager {
    static let shared = DataManager()
    
    public var delegate: DataManagerDelegate?
    
    open var person: Person
    
    private init() {
        self.person = Person()
    }
    
    func getAllContainers() {
        RequestManager.shared.getAllContainers()
    }
    
    func allContainersReceived(_ data: JSON) {
        var containers: [Container] = []
        
        for container in data.arrayValue {
            containers.append(Container(container))
        }
        person.containers = containers
        delegate?.allContainersUpdate()
    }
    
    func makeContainerActionWith(_ id: String, _ action: ContainerAction) {
        RequestManager.shared.makeContainerActionWith(id, action)
    }
    
    func resultOfContainerActionWith(_ id: String, _ action: ContainerAction, isError: Bool) {
        inspectContainerWith(id)
        delegate?.resultOfContainerActionWith(id, action, isError: isError)
    }
    
    func inspectContainerWith(_ id: String) {
        RequestManager.shared.inspectContainerWith(id)
    }
    
    func receivedInformationAbountContainerWith(_ id: String, data: JSON) {
        delegate?.updateContainerWith(id, data: data)
    }
}
