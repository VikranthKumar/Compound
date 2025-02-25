//
//  Animation++.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import SwiftUI

extension Animation {
    static func smoothSpring() -> Animation {
        spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.2)
    }
}
