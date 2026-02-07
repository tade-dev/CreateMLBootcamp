//
//  Double+Extensions.swift
//  CreateMLBootcamp
//
//  Created by BSTAR on 06/02/2026.
//

import SwiftUI

extension Double {
    
    func toPercentage() -> String {
        return String(format: "%.0f", (self * 100))
    }
    
}
