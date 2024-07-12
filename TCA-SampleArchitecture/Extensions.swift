//
//  Extensions.swift
//  TCA-SampleArchitecture
//
//  Created by Ramakrishnan, Balaji (Cognizant) on 11/07/24.
//

import Foundation

let df = DateFormatter()

extension Date {
        
    func toString(format: String) -> String {
        df.dateFormat = format
        return df.string(from: self)
    }
}

extension String {
    
    func toDate(format: String) -> Date? {
        df.dateFormat = format
        return df.date(from: self)
    }
}
