//
//  Optional++.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import Foundation

extension Optional where Wrapped == String {
    var unWrapped: String {
        self ?? .empty
    }
    
    var intValue: Int {
        Int(self.unWrapped).unWrapped
    }
}

extension Optional where Wrapped == Int {
    var unWrapped: Int {
        self ?? 0
    }
    
    var stringValue: String {
        String(self.unWrapped)
    }
}
