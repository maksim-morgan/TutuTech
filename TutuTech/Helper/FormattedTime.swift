//
//  FormattedTime.swift
//  TutuTech
//
//  Created by Mrmaks on 06.05.2025.
//

import Foundation
import CoreLocation

class FormattedTime {
    func formatTime(_ iso: String, timeZone: TimeZone?) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
         dateFormatter.locale = Locale(identifier: "en_US_POSIX")
         dateFormatter.timeZone = timeZone ?? .current
         
        
        let output = DateFormatter()
        output.timeStyle = .short
        output.amSymbol = "am"
        output.pmSymbol = "pm"
        output.locale = Locale(identifier: "en_US")
        
        guard let date = dateFormatter.date(from: iso) else { return "Invalid" }
        return output.string(from: date)
    }
    
    func getTimeZone(for latitude: Double, longitude: Double, completion: @escaping (TimeZone?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let timeZone = placemarks?.first?.timeZone, error == nil else {
                completion(nil)
                return
            }
            completion(timeZone)
        }
    }
}
