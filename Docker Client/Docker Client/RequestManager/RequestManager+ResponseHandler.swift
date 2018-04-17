//
//  RequestManager+ResponseHandler.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 17.04.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import SwiftyJSON
import Alamofire

enum RequestType {
    
    case allContainers
    case startContainerWith(String)
    case stopContainerWith(String)
    case pauseContainerWith(String)
    case restartContainerWith(String)
    
    func path() -> String {
        switch self {
        case .allContainers:
            return DataManager.shared.person.server! + BackendString.pthAllContainers
        case let .startContainerWith(id):
            return DataManager.shared.person.server! + "\(BackendString.pthContainers)/\(id)/start"
        case let .stopContainerWith(id):
            return DataManager.shared.person.server! + "\(BackendString.pthContainers)/\(id)/stop"
        case let .pauseContainerWith(id):
            return DataManager.shared.person.server! + "\(BackendString.pthContainers)/\(id)/pause"
        case let .restartContainerWith(id):
            return DataManager.shared.person.server! + "\(BackendString.pthContainers)/\(id)/restart"
        }
    }
}

extension RequestManager {
    func dataReceived(requestType: RequestType, method: HTTPMethod, data: DataResponse<Any>) {
        var json: JSON?
        var isError: Bool = false
        var err: Error?
        
        switch data.result {
        case .success(_):
            json = try! JSON(data: data.data!)
        case .failure(let value):
            isError = true
            err = value
        }
        
        switch (method, requestType, isError) {
        case (.get, .allContainers, false):
            DataManager.shared.allContainersReceived(json!)
        case (.get, .allContainers, true):
            print("Error", err!)
        case (.post, let .startContainerWith(id), false):
            print("Started \(id)")
        case (.post, let .startContainerWith(id), true):
            print("Start error \(id)")
        case (.post, let .stopContainerWith(id), false):
            print("Stopped \(id)")
        case (.post, let .stopContainerWith(id), true):
            print("Stop error \(id)")
        case (.post, let .pauseContainerWith(id), false):
            print("Paused \(id)")
        case (.post, let .pauseContainerWith(id), true):
            print("Pause error \(id)")
        case (.post, let .restartContainerWith(id), false):
            print("Restarted \(id)")
        case (.post, let .restartContainerWith(id), true):
            print("Restart error \(id)")
        default:
            print("Response not handled")
        }
    }
}
