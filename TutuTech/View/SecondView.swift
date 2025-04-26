//
//  SecondView.swift
//  TutuTech
//
//  Created by Mrmaks on 25.04.2025.
//

import Foundation
import UIKit
import SnapKit

final class SecondViewUI: UIView {
    
    let imageView = UIImageView()
    let stackView = UIStackView()
    let timeLabel = UILabel()
    let temperatureLabel = UILabel()
    let windSpeedLabel = UILabel()
    let humidityLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupStackView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        addSubview(imageView)
        imageView.image = UIImage(named: "AppBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        sendSubviewToBack(imageView)
    }

    private func setupStackView() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 12
        stackView.backgroundColor = .systemGray6
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true

        timeLabel.font = .systemFont(ofSize: 16)
        timeLabel.textColor = .darkGray
        
        temperatureLabel.font = .systemFont(ofSize: 16)
        temperatureLabel.textColor = .systemBlue

        windSpeedLabel.font = .systemFont(ofSize: 16)
        windSpeedLabel.textColor = .systemGreen

        humidityLabel.font = .systemFont(ofSize: 16)
        humidityLabel.textColor = .darkGray

        [timeLabel, temperatureLabel, windSpeedLabel, humidityLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(220)
            make.centerX.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(150)
        }
    }
}

