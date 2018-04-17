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
}

class DataManager {
    static let shared = DataManager()
    
    public var delegate: DataManagerDelegate?
    
    open var person: Person
    
    private init() {
        self.person = Person()
    }
    
    func allContainersReceived(_ data: JSON) {
        var containers: [Container] = []
        print(data)
        for container in data.arrayValue {
            let id: String = container["Id"].stringValue
            let image: String = container["Image"].stringValue
            let names: [String] = container["Names"].arrayObject as! [String]
            let created: Date = Date.init(timeIntervalSince1970: TimeInterval(container["Created"].intValue))
            containers.append(Container(id: id, names: names, created: created))
        }
        person.containers = containers
        delegate?.allContainersUpdate()
    }
}
