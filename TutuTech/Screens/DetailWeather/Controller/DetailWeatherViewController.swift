//
//  BostonViewController.swift
//  TutuTech
//
//  Created by Mrmaks on 14.04.2025.
//

import Foundation
import UIKit
import SnapKit

final class DetailWeatherViewController: UIViewController {
    
    let viewModel: DetailWeatherViewModel
    private let cityName: String
    private let secondView = DetailWeatherView()
    private var homeLat: Double
    private var homeLon: Double
    
    init (viewModel: DetailWeatherViewModel, cityName: String, homeLat: Double, homeLon: Double) {
        self.viewModel = viewModel
        self.cityName = cityName
        self.homeLat = homeLat
        self.homeLon = homeLon
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = cityName
        bindViewModel()
        viewModel.onViewDidLoad(lat: homeLat, lon: homeLon)
    }

    override func loadView() {
        view = secondView
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self else { return }
            secondView.timeLabel.text = "Time: \(viewModel.detailCityModel.time)"
            secondView.temperatureLabel.text = "Temperature: \(viewModel.detailCityModel.temperature)"
            secondView.windSpeedLabel.text = "Wind: \(viewModel.detailCityModel.windSpeed)"
            secondView.humidityLabel.text = "Humidity: \(viewModel.detailCityModel.humidity)"
        }
    }
}
