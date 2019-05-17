//
//  Endpoints.swift
//  TabletChallenge
//
//  Created by Felix Changoo on 4/8/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation

struct API {
    static let baseUrl = "https://images-api.nasa.gov"
}

protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

enum Endpoints {
    
    enum Images: Endpoint {
        case search
        
        public var path: String {
            switch self {
                case .search: return "/search"
            }
        }
        
        public var url: String {
            switch self {
                case .search: return "\(API.baseUrl)\(path)"
            }
        }
    }
}
