//
//  Functions.swift
//  DoneList
//
//  Created by  on 2023/07/08.
//

import Foundation

func convertStringToDate(dateValue: String, dateFormat: String = "yyyyMMddHHmmss") -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.date(from: dateValue)
}

func toDateString(dateValue: String, dateFormat: String) -> String {
    if let date = convertStringToDate(dateValue: dateValue) {
        return toDateString(dateValue: date, dateFormat: dateFormat)
    } else {
        return ""
    }
}

func toDateString(dateValue: Date?, dateFormat: String) -> String {
    guard let validDate = dateValue else {
        return ""
    }
    
    let newDateFormatter = DateFormatter()
    newDateFormatter.dateFormat = dateFormat
    let newDateString = newDateFormatter.string(from: validDate)
    return newDateString
}

// 差分を計算して"HH:mm"形式で返す関数
func calculateTimeDifference(startDate: Date?, endDate: Date?) -> String {
    var result = ""
    
    if let sd = startDate, let ed = endDate {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: sd, to: ed)
        
        if let hours = components.hour, let minutes = components.minute {
            let timeString = String(format: "%02d:%02d", hours, minutes)
            result = timeString
        } else {
            result = ""
        }
    }
    return result
}

func getWeekdayFromDate(date: Date?) -> String {
    var result = "？"
    
    if let date = date {
        let calendar = Calendar.current
        let components = calendar.component(.weekday, from: date)
        
        switch components {
        case 1:
            result = "日"
        case 2:
            result =  "月"
        case 3:
            result =  "火"
        case 4:
            result =  "水"
        case 5:
            result =  "木"
        case 6:
            result =  "金"
        case 7:
            result =  "土"
        default:
            result =  "？"
        }
    }
    
    return result
}
