//
//  HomeView.swift
//  TutuTech
//
//  Created by Mrmaks on 21.04.2025.
//

import Foundation
import UIKit
import SnapKit

final class HomeView: UIView {
    
    private let imageView = UIImageView()
    let tableView = UITableView()
    let searchBar = UISearchBar()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupSearchBar()
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        addSubview(imageView)
        imageView.image = UIImage(named: "AppBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupSearchBar() {
        addSubview(searchBar)
        searchBar.placeholder = "Search for a city"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }

    private func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
@available(iOS 17, *)
#Preview("HomeView") {
    let view = HomeView()
    return view
}
