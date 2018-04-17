//
//  RequestManager+Interactions.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 17.04.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import Alamofire

extension RequestManager {
    func getAllContainers() {
        let parameters: Parameters = [
            "all": true
        ]
        
        RequestManager.shared._baseGET(.allContainers, parameters: parameters)
    }
    
    func startContainerWith(_ id: String) {
        RequestManager.shared._basePOST(.startContainerWith(id), parameters: nil)
    }
    
    func stopContainerWith(_ id: String) {
        RequestManager.shared._basePOST(.stopContainerWith(id), parameters: nil)
    }
    
    func pauseContainerWith(_ id: String) {
        RequestManager.shared._basePOST(.pauseContainerWith(id), parameters: nil)
    }
    
    func restartContainerWith(_ id: String) {
        RequestManager.shared._basePOST(.restartContainerWith(id), parameters: nil)
    }
}
