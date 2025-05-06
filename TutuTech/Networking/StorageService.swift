//
//  StorageService.swift
//  TutuTech
//
//  Created by Mrmaks on 26.04.2025.
//

import Foundation

final class StorageService {
    
    private let citiesKey = "savedCities"
    private let detailedWeatherKey = "savedDetailedWeather"
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Работа с городами
    func saveCities(_ cities: [CityWeather]) {
        if let data = try? JSONEncoder().encode(cities) {
            userDefaults.set(data, forKey: citiesKey)
        }
    }
    
    func loadCities() -> [CityWeather] {
        guard let data = userDefaults.data(forKey: citiesKey),
              let cities = try? JSONDecoder().decode([CityWeather].self, from: data) else {
            return []
        }
        return cities
    }
    
    // MARK: - Работа с детальной погодой
    func saveDetailedWeather(_ weather: DetailWeather) {
        var weathers = loadAllDetailedWeather()
        weathers.removeAll { $0.latitude == weather.latitude && $0.longitude == weather.longitude }
        weathers.append(weather)
        
        if let data = try? JSONEncoder().encode(weathers) {
            userDefaults.set(data, forKey: detailedWeatherKey)
        }
    }
    
    func loadDetailedWeather(forLatitude latitude: Double, longitude: Double) -> DetailWeather? {
        let weathers = loadAllDetailedWeather()
        return weathers.first { $0.latitude == latitude && $0.longitude == longitude }
    }
    
    private func loadAllDetailedWeather() -> [DetailWeather] {
        guard let data = userDefaults.data(forKey: detailedWeatherKey),
              let weathers = try? JSONDecoder().decode([DetailWeather].self, from: data) else {
            return []
        }
        return weathers
    }
}
