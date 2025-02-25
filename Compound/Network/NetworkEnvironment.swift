//
//  NetworkEnvironment.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/23/25.
//

import Foundation

enum NetworkEnvironment {
    case development
    case production
}

extension NetworkEnvironment {
    static var active: NetworkEnvironment {
        .production
    }
    
    var baseUrl: String {
        "https://lvmve.wiremockapi.cloud"
    }
}
