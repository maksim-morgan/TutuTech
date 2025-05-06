//
//  TableViewCell.swift
//  TutuTech
//
//  Created by Mrmaks on 05.05.2025.
//

import Foundation
import UIKit
import SnapKit

class CityTableViewCell: UITableViewCell {
    
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    static let reuseIdentifier = "CityCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        cityLabel.font = .systemFont(ofSize: 18, weight: .medium)
        tempLabel.font = .systemFont(ofSize: 16)
        tempLabel.textColor = .gray

        contentView.addSubview(cityLabel)
        contentView.addSubview(tempLabel)

        cityLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with name: String, temperature: String) {
        cityLabel.text = name
        tempLabel.text = temperature
    }
}
