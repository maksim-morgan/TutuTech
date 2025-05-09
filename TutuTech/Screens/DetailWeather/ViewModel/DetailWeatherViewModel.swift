//
//  SecondViewModel.swift
//  TutuTech
//
//  Created by Mrmaks on 25.04.2025.
//

import Foundation

final class DetailWeatherViewModel {
    
    var timeFormatter = FormattedTime()
    var detailCityModel: DetailCityModel
    var onDataUpdated: (() -> Void)?
    let apiService: ApiService
    private let storageService: StorageService
    private let networkMonitor: NetworkMonitor
    
    init(detailCityModel: DetailCityModel, onDataUpdated: ( () -> Void)? = nil, apiService: ApiService, storageService: StorageService, networkMonitor: NetworkMonitor) {
        self.detailCityModel = detailCityModel
        self.onDataUpdated = onDataUpdated
        self.apiService = apiService
        self.storageService = storageService
        self.networkMonitor = networkMonitor
    }
    
    func onViewDidLoad(lat: Double, lon: Double) {
        fetchWeather(lat: lat, lon: lon) {
            self.onDataUpdated?()
        }
    }
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping () -> Void) {
        let updateUI: () -> Void = {
            self.onDataUpdated?()
            completion()
        }

        guard networkMonitor.isConnected else {
            if let cached = storageService.loadDetailedWeather(forLatitude: lat, longitude: lon) {
                detailCityModel = .init(from: cached)
            } else {
                detailCityModel = .placeholder
            }

            DispatchQueue.main.async(execute: updateUI)
            return
        }

        apiService.fetchWeather(lat: lat, lon: lon) { [weak self] temp, time, wind, humidity in
            guard let self else { return }

            self.timeFormatter.getTimeZone(for: lat, longitude: lon) { timeZone in
                let formattedTime = self.timeFormatter.formatTime(time, timeZone: timeZone)

                self.detailCityModel = DetailCityModel(
                    temperature: "\(temp)°C",
                    time: formattedTime,
                    windSpeed: "\(wind) m/s",
                    humidity: "\(Int(humidity ?? 0))%"
                )

                let detailedWeather = DetailWeather(
                    latitude: lat,
                    longitude: lon,
                    temperature: self.detailCityModel.temperature,
                    time: self.detailCityModel.time,
                    windSpeed: self.detailCityModel.windSpeed,
                    humidity: self.detailCityModel.humidity
                )

                self.storageService.saveDetailedWeather(detailedWeather)

                DispatchQueue.main.async(execute: updateUI)
            }
        }
    }
}
    
    
    
