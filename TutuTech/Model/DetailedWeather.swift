//
//  DetailedWeather.swift
//  TutuTech
//
//  Created by Mrmaks on 26.04.2025.
//

import Foundation

struct DetailedWeather: Codable {
    let latitude: Double
    let longitude: Double
    let temperature: String
    let time: String
    let windSpeed: String
    let humidity: String
}
