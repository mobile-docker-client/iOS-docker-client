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
    
    func path() -> String {
        switch self {
        case .allContainers:
            return "http://46.101.7.101:2376" + BackendString.pthAllContainers
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
        default:
            print("Response not handled")
        }
    }
}
