//
//  FormattedTime.swift
//  TutuTech
//
//  Created by Mrmaks on 06.05.2025.
//

import Foundation

class FormattedTime {
     func formatTime(_ iso: String) -> String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd'T'HH:mm"
        input.locale = Locale(identifier: "en_US_POSIX")
        
        let output = DateFormatter()
        output.timeStyle = .short
        output.amSymbol = "am"
        output.pmSymbol = "pm"
        output.locale = Locale(identifier: "en_US")
        
        guard let date = input.date(from: iso) else { return "Invalid" }
        return output.string(from: date)
    }
}
