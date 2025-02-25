//
//  String++.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import Foundation

extension String {
    var firstName: String {
        components(separatedBy: String.space).first ?? self
    }
}
