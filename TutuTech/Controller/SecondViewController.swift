//
//  BostonViewController.swift
//  TutuTech
//
//  Created by Mrmaks on 14.04.2025.
//

import Foundation
import UIKit
import SnapKit

final class SecondViewController: UIViewController {
    
    private let viewModel: SecondViewModel
    private let cityName: String
    private let secondView = SecondViewUI()
    private var homeLat: Double = 0
    private var homeLon: Double = 0
    
    init(viewModel: SecondViewModel, cityName: String) {
        self.viewModel = viewModel
        self.cityName = cityName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = cityName
        bindViewModel()
        viewModel.fetchWeather(lat: homeLat, lon: homeLon, completion: {
            self.viewModel.onDataUpdated?()
        })
    }

    override func loadView() {
        view = secondView
    }

    func setCoordinates(lat: Double, lon: Double) {
        homeLat = lat
        homeLon = lon
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self else { return }
            secondView.timeLabel.text = "Time: \(viewModel.time)"
            secondView.temperatureLabel.text = "Temperature: \(viewModel.temperature)"
            secondView.windSpeedLabel.text = "Wind: \(viewModel.windSpeed)"
            secondView.humidityLabel.text = "Humidity: \(viewModel.humidity)"
        }
    }
}
