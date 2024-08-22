//
//  Date+.swift
//  EmoJournal
//
//  Created by 김태훈 on 8/22/24.
//

import Foundation

extension Date {
    func toyyyymmdd() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: self)
        
        return dateStr
    }
}
