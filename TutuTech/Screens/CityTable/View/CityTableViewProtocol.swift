//
//  CityTableViewProtocol.swift
//  TutuTech
//
//  Created by Mrmaks on 11.05.2025.
//

import Foundation

protocol CityTableViewProtocol {
    var cities: [CityWeather] { get }
    var filteredCities: [CityWeather] { get set }
    var isDataFromCache: Bool { get }
}
