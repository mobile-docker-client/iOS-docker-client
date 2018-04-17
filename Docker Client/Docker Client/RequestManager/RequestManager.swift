//
//  RequestManager.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 17.04.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import Alamofire
import SwiftyJSON

class RequestManager {
    static let shared = RequestManager()
    
    func _baseGET(_ requestType: RequestType, parameters: Parameters? = nil) {
        Alamofire.request(requestType.path(), method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseJSON(completionHandler: { response in
                self.dataReceived(requestType: requestType, method: .get, data: response)
            })
    }
    
    func _basePOST(_ requestType: RequestType, parameters: Parameters? = nil) {
        Alamofire.request(requestType.path(), method: .post, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseJSON(completionHandler: { response in
                self.dataReceived(requestType: requestType, method: .post, data: response)
            })
    }
}
