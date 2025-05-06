//
//  HomeViewModel.swift
//  TutuTech
//
//  Created by Mrmaks on 21.04.2025.
//

import Foundation
import UIKit

protocol CityTableViewProtocol {
    var cities: [CityWeather] { get }
    var filteredCities: [CityWeather] { get set }
    var isDataFromCache: Bool { get }
}

class HomeViewModel: CityTableViewProtocol {
    private(set) var cities: [CityWeather]
    var filteredCities: [CityWeather]
    private(set) var isDataFromCache = false
    var apiService = ApiService()
    private let storageService = StorageService()
    var networkMonitor = NetworkMonitor()
    
    init() {
        cities = storageService.loadCities()
        filteredCities = cities
        if cities.isEmpty {
            cities = [
                CityWeather(name: "Boston", latitude: 42.361145, longitude: -71.057083, temperature: ""),
                CityWeather(name: "New York", latitude: 40.730610, longitude: -73.935242, temperature: ""),
                CityWeather(name: "Los Angeles", latitude: 34.052235, longitude: -118.243683, temperature: ""),
                CityWeather(name: "Sacramento", latitude: 38.575764, longitude: -121.478851, temperature: "")
            ]
            filteredCities = cities
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "No internet", message: "Internet connection is required", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func fetchTemperatures(completion: @escaping () -> Void) {
        if networkMonitor.isConnected == false {
            showAlert()
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
    }

    func addCity(with name: String, latitude: Double, longitude: Double, completion: @escaping () -> Void) {
        apiService.fetchWeather(lat: latitude, lon: longitude) { [weak self] temperature, time, windSpeed, humidity in
            guard let self else { return }
            let newCity = CityWeather(name: name, latitude: latitude, longitude: longitude, temperature: "\(temperature)°C")
            self.cities.append(newCity)
            self.filteredCities = self.cities
            self.storageService.saveCities(self.cities)
            completion()
        }
    }
}
