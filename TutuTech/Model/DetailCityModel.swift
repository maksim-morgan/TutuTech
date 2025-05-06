//
//  DetailCityModel.swift
//  TutuTech
//
//  Created by Mrmaks on 06.05.2025.
//

import Foundation

struct DetailCityModel {
    var temperature: String = ""
    var time: String = ""
    var windSpeed: String = ""
    var humidity: String = ""
}

extension DetailCityModel {
    static let placeholder = DetailCityModel(
        temperature: "N/A", time: "N/A", windSpeed: "N/A", humidity: "N/A"
    )

    init(from weather: DetailWeather) {
        self.init(
            temperature: weather.temperature,
            time: weather.time,
            windSpeed: weather.windSpeed,
            humidity: weather.humidity
        )
    }
}
