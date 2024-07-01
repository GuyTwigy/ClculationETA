//
//  Utils.swift
//  ClculationETA
//
//  Created by Guy Twig on 01/07/2024.
//

import Foundation

class Utils {
    
    static func formatTime(seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds) seconds"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            return "\(minutes):\(String(format: "%02d", remainingSeconds)) min"
        } else {
            let hours = seconds / 3600
            let remainingMinutes = (seconds % 3600) / 60
            return "\(hours):\(String(format: "%02d", remainingMinutes)) hour"
        }
    }
    
    static func addSecondsToTime(nowTime: String, seconds: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"

        guard let currentDate = dateFormatter.date(from: nowTime) else {
            return nil
        }

        var newTime = ""
        if let newDate = Calendar.current.date(byAdding: .second, value: seconds, to: currentDate) {
            newTime = dateFormatter.string(from: newDate)
        }
        
        return "\(newTime)"
    }
}
