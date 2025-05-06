//
//  Protocols.swift
//  TutuTech
//
//  Created by Mrmaks on 06.05.2025.
//

import Foundation

protocol CityTableViewProtocol {
    var cities: [CityWeather] { get }
    var filteredCities: [CityWeather] { get set }
    var isDataFromCache: Bool { get }
}

protocol ApiServiceProtocol {
    var apiService: ApiService { get set }
}
