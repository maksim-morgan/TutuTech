//
//  HomeView.swift
//  TutuTech
//
//  Created by Mrmaks on 21.04.2025.
//

import Foundation
import UIKit
import SnapKit

final class CityTableView: UIView {
    
    private let imageView = UIImageView()
    private(set) var tableView = UITableView()
    private(set) var searchBar = UISearchBar()

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
        setupImageView()
        setupSearchBar()
        setupTableView()
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.image = UIImage(named: Constants.appBackgroundImage)
        imageView.contentMode = .scaleAspectFill
    }
    
    private func setupSearchBar() {
        addSubview(searchBar)
        searchBar.placeholder = Constants.searchBarPlaceholder
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityCell")
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(Constants.sixteen)
            make.height.equalTo(Constants.fortyFour)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Constants.eight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension CityTableView {
    enum Constants {
        static let appBackgroundImage: String = "AppBackground"
        static let searchBarPlaceholder: String = "Search for a city"
        static let eight: CGFloat = 8
        static let sixteen: CGFloat = 16
        static let fortyFour: CGFloat = 44
    }
}
