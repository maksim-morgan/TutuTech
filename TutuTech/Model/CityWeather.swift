//
//  CityWeather.swift
//  TutuTech
//
//  Created by Mrmaks on 21.04.2025.
//

import Foundation
import UIKit

struct CityWeather: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    var temperature: String
}
