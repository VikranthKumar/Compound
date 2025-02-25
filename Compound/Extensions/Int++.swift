//
//  Int++.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import Foundation

extension Int {
    var toString: String {
        "\(self)"
    }
    
    var countSuffix: String {
        self == 1 ? .empty : .s
    }
}
