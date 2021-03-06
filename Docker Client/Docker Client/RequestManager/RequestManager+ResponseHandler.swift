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
    case containerActionWith(String, ContainerAction)
    case inspectContainerWith(String)
    
    func path() -> String {
        switch self {
        case .allContainers:
            return DataManager.shared.person.server! + BackendString.pthAllContainers
        case let .containerActionWith(id, action):
            return DataManager.shared.person.server! + "\(BackendString.pthContainers)/\(id)/\(action.rawValue)"
        case let .inspectContainerWith(id):
            return DataManager.shared.person.server! + "\(BackendString.pthContainers)/\(id)/json"
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
            json = try? JSON(data: data.data!)
        case .failure(let value):
            isError = true
            err = value
        }
        
        switch (method, requestType, isError) {
        case (.get, .allContainers, false):
            DataManager.shared.allContainersReceived(json!)
        case (.get, .allContainers, true):
            print("Error", err!)
            break
        case (.post, let .containerActionWith(id, action), _):
            DataManager.shared.resultOfContainerActionWith(id, action, isError: isError)
        case (.get, let .inspectContainerWith(id), false):
            DataManager.shared.receivedInformationAbountContainerWith(id, data: json!)
            break
        case (.get, let .inspectContainerWith(id), true):
            print("Error", err!)
            break
        default:
            print("Response not handled")
        }
    }
}
