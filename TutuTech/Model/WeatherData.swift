//
//  WeatherData.swift
//  TutuTech
//
//  Created by Mrmaks on 21.04.2025.
//

import Foundation

struct WeatherData: Decodable {
    let currentWeather: CurrentWeather
    let hourly: Hourly

    enum CodingKeys: String, CodingKey {
        case currentWeather = "current_weather"
        case hourly
    }
}

struct CurrentWeather: Decodable {
    let temperature: Double
    let windspeed: Double
    let time: String
}

struct Hourly: Codable {
    let time: [String]
    let temperature2M: [Double]
    let relativeHumidity2M: [Int]
    let windSpeed10M: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case windSpeed10M = "wind_speed_10m"
    }
}
