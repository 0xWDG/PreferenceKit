//
//  Date+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2024-08-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

extension Date {
    /// Create a date from a string in the format "YYYY-MM-DD"
    /// - Parameter yyyymmdd: The date string in the format "YYYY-MM-DD"
    public init?(yyyymmdd: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: yyyymmdd) else {
            return nil
        }
        self = date
    }

    /// Date in YYYY-MM-DD format (zero-padded, sortable)
    var yyyymmdd: String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    /// Date in DD-MM-YYYY format (zero-padded, sortable)
    var ddmmyyyy: String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return String(format: "%02d-%02d-%04d", day, month, year)
    }
}
