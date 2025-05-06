//
//  SecondViewModel.swift
//  TutuTech
//
//  Created by Mrmaks on 25.04.2025.
//

import Foundation

final class DetailWeatherViewModel {
    
    var temperature: String = ""
    var time: String = ""
    var windSpeed: String = ""
    var humidity: String = ""
    var onDataUpdated: (() -> Void)?
    private let apiService = ApiService()
    private let networkMonitor = NetworkMonitor()
    private let storageService = StorageService()
    
    func onViewDidLoad(lat: Double, lon: Double) {
        fetchWeather(lat: lat, lon: lon) {
            self.onDataUpdated?()
        }
    }
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping () -> Void) {
        if networkMonitor.isConnected {
            apiService.fetchWeather(lat: lat, lon: lon) { [weak self] temp, time, wind, humidity in
                guard let self else { return }
                
                self.temperature = "\(Int(temp))°C"
                self.time = self.formatTime(time)
                self.windSpeed = "\(wind) m/s"
                self.humidity = "\(Int(humidity ?? 0))%"
                
                let detailedWeather = DetailWeather(
                    latitude: lat,
                    longitude: lon,
                    temperature: self.temperature,
                    time: self.time,
                    windSpeed: self.windSpeed,
                    humidity: self.humidity
                )
                self.storageService.saveDetailedWeather(detailedWeather)
                
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                    completion()
                }
            }
        } else {
            // Загрузка из кэша
            if let cached = storageService.loadDetailedWeather(forLatitude: lat, longitude: lon) {
                self.temperature = cached.temperature
                self.time = cached.time
                self.windSpeed = cached.windSpeed
                self.humidity = cached.humidity
            } else {
                // Заглушка
                self.temperature = "N/A"
                self.time = "N/A"
                self.windSpeed = "N/A"
                self.humidity = "N/A"
            }
            
            DispatchQueue.main.async {
                self.onDataUpdated?()
                completion()
            }
        }
    }
        
    private func formatTime(_ iso: String) -> String {
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
    
    
    
