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
    
    func makeContainerActionWith(_ id: String, _ action: ContainerAction) {
        RequestManager.shared._basePOST(.containerActionWith(id, action))
    }
    
    func inspectContainerWith(_ id: String) {
        RequestManager.shared._baseGET(.inspectContainerWith(id))
    }
}
