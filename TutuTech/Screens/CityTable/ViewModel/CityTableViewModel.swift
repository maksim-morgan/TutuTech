//
//  HomeViewModel.swift
//  TutuTech
//
//  Created by Mrmaks on 21.04.2025.
//

import Foundation
import UIKit

class CityTableViewModel: CityTableViewProtocol {
    var cities: [CityWeather]
    var filteredCities: [CityWeather]
    private(set) var isDataFromCache = false
    
    let apiService: ApiService
    private let storageService: StorageService
    private let networkMonitor: NetworkMonitor
    private let router: AlertRouter
    
    init(apiService: ApiService, storageService: StorageService, networkMonitor: NetworkMonitor, router: AlertRouter) {
       
        self.apiService = apiService
        self.storageService = storageService
        self.networkMonitor = networkMonitor
        self.router = router
        
        cities = storageService.loadCities()
        filteredCities = cities
        if cities.isEmpty {
            self.cities = [
                CityWeather(name: "Boston", latitude: 42.361145, longitude: -71.057083, temperature: ""),
                CityWeather(name: "New York", latitude: 40.730610, longitude: -73.935242, temperature: ""),
                CityWeather(name: "Los Angeles", latitude: 34.052235, longitude: -118.243683, temperature: ""),
                CityWeather(name: "Sacramento", latitude: 38.575764, longitude: -121.478851, temperature: "")
            ]
            filteredCities = cities
        }
    }
    
    func fetchTemperatures(completion: @escaping () -> Void) {
        if networkMonitor.isConnected == false {
            router.showAlert()
        }
        
        let group = DispatchGroup()
        
        for (index, city) in cities.enumerated() {
            group.enter()
            apiService.fetchWeather(lat: city.latitude, lon: city.longitude) { [weak self] temperature, time, windSpeed, humidity in
                guard let self else { return }
                self.cities[index].temperature = "\(temperature)°C"
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
                self.isDataFromCache = false
                self.storageService.saveCities(self.cities)
                completion()
        }
    }

    func searchCities(query: String) {
        if query.isEmpty {
            filteredCities = cities
        } else {
            filteredCities = cities.filter { city in
                return city.name.lowercased().contains(query.lowercased())
            }
        }
        
        if filteredCities.isEmpty {
            router.nothingWasFound()
        }
    }

    func addCity(with info: CityInfo, completion: @escaping () -> Void) {
        apiService.fetchWeather(lat: info.latitude, lon: info.longitude) { [weak self] temperature, time, windSpeed, humidity in
            guard let self else { return }
            
            let newCity = CityWeather(
                name: info.name,
                latitude: info.latitude,
                longitude: info.longitude,
                temperature: "\(temperature)°C"
            )
            
            self.cities.append(newCity)
            self.filteredCities = self.cities
            self.storageService.saveCities(self.cities)
            completion()
        }
    }
    
    func fetchSuggestions(query: String, completion: @escaping () -> Void) {
        apiService.fetchCitySuggestions(query: query) { [weak self] suggestions in
            guard let self else { return }

            self.filteredCities = suggestions.map {
                CityWeather(name: $0.name, latitude: $0.latitude, longitude: $0.longitude, temperature: "")
            }
            completion()
        }
    }
}
