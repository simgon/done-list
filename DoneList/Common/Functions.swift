//
//  Functions.swift
//  DoneList
//
//  Created by  on 2023/07/08.
//

import Foundation

func toDateString(dateValue: String, dateFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    if let date = dateFormatter.date(from: dateValue) {
        return toDateString(dateValue: date, dateFormat: dateFormat)
    } else {
        return ""
    }
}

func toDateString(dateValue: Date, dateFormat: String) -> String {
    let newDateFormatter = DateFormatter()
    newDateFormatter.dateFormat = dateFormat
    let newDateString = newDateFormatter.string(from: dateValue)
    return newDateString
}
