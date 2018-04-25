//
//  Server.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 25.04.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import Foundation

class Server: Codable {
    var name: String?
    var url: String?
    
    init(url: String, name: String?) {
        self.name = name
        self.url = url
    }
}
