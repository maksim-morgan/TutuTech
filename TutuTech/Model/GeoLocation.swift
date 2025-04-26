//
//  GeoLocation.swift
//  TutuTech
//
//  Created by Mrmaks on 21.04.2025.
//

import Foundation

struct GeoCodingResponse: Decodable {
    let results: [GeoLocation]
}

struct GeoLocation: Decodable {
    let name: String
    let latitude: Double
    let longitude: Double
}
