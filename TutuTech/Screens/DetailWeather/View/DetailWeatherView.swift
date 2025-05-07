//
//  SecondView.swift
//  TutuTech
//
//  Created by Mrmaks on 25.04.2025.
//

import Foundation
import UIKit
import SnapKit

final class DetailWeatherView: UIView {
    
    private let imageView = UIImageView()
    private let stackView = UIStackView()
    let timeLabel = UILabel()
    let temperatureLabel = UILabel()
    let windSpeedLabel = UILabel()
    let humidityLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupInitialState()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupInitialState()
    }
    
    private func setupInitialState() {
        setupStackView()
        setupImageView()
        setupStackView()
        setupTimeLabel()
        setupTemperatureLablel()
        setupWindSpeedLabel()
        setupHumidityLabel()
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.image = UIImage(named: "AppBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        sendSubviewToBack(imageView)
    }
    
    private func setupTimeLabel() {
        timeLabel.font = .systemFont(ofSize: Constants.labelSize)
        timeLabel.textColor = .darkGray
    }
    
    private func setupTemperatureLablel() {
        temperatureLabel.font = .systemFont(ofSize: Constants.labelSize)
        temperatureLabel.textColor = .systemBlue
    }
    
    private func setupWindSpeedLabel() {
        windSpeedLabel.font = .systemFont(ofSize: Constants.labelSize)
        windSpeedLabel.textColor = .systemGreen
    }
    
    private func setupHumidityLabel() {
        humidityLabel.font = .systemFont(ofSize: Constants.labelSize)
        humidityLabel.textColor = .darkGray
    }

    private func setupStackView() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = Constants.ten
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = Constants.twelve
        stackView.backgroundColor = .systemGray6
        stackView.layoutMargins = UIEdgeInsets(top: Constants.twelve, left: Constants.twelve, bottom: Constants.twelve, right: Constants.twelve)
        stackView.isLayoutMarginsRelativeArrangement = true

        [timeLabel, temperatureLabel, windSpeedLabel, humidityLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.twoHundredTwenty)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.twoHundredFourty)
            make.height.equalTo(Constants.oneHundredSixty)
        }
    }
}

extension DetailWeatherView {
    enum Constants {
        static let ten: CGFloat = 10
        static let twelve: CGFloat = 12
        static let labelSize: CGFloat = 16
        static let twoHundredTwenty: CGFloat = 220
        static let twoHundredFourty: CGFloat = 224
        static let oneHundredSixty: CGFloat = 160
    }
}

