//
//  HomeScreenModel.swift
//  TutuTech
//
//  Created by Mrmaks on 20.04.2025.
//

import Foundation

class ApiService {
    func fetchWeather(lat: Double, lon: Double, completion: @escaping (Double, String, Double, Int?) -> Void) {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                let temp = weatherData.currentWeather.temperature
                let time = weatherData.currentWeather.time
                let wind = weatherData.currentWeather.windspeed
                let humidity = weatherData.hourly.relativeHumidity2M.first
                completion(temp, time, wind, humidity)
            } catch {
                print("Error decoding:", error)
            }
        }.resume()
    }
    
    func fetchCityCoordinates(cityName: String, completion: @escaping (Double?, Double?) -> Void) {
        let query = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(query)&count=1&language=en&format=json"

        guard let url = URL(string: urlString) else {
            completion(nil, nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                completion(nil, nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(GeoCodingResponse.self, from: data)
                if let first = result.results.first {
                    completion(first.latitude, first.longitude)
                } else {
                    completion(nil, nil)
                }
            } catch {
                print("Geo decode error:", error)
                completion(nil, nil)
            }
        }.resume()
    }
}

