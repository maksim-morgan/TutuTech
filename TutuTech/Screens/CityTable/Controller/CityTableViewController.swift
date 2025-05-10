import UIKit
import SnapKit

class CityTableViewController: UIViewController, UITableViewDelegate {
    
    private let alertRouter: AlertRouter
    private let tableViewScreen = CityTableView()
    private let cityTableViewModel: CityTableViewModel
    private let apiService = ApiService()
    private let detailCityModel = DetailCityModel()
    private let storageService = StorageService()
    private let networkMonitor = NetworkMonitor()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupHomeView()
        setupNavigationBarStyle()
        addKeyboardDismissTap()
        fetchTemperatures()
        setupRefreshControl()
        refreshData()
        tableViewScreen.getTableView().delegate = self
        tableViewScreen.getTableView().dataSource = self
        tableViewScreen.getSearchBar().delegate = self
    }
    
    init(cityTableViewModel: CityTableViewModel, alertRouter: AlertRouter) {
        self.cityTableViewModel = cityTableViewModel
        self.alertRouter = alertRouter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableViewScreen.getTableView().refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        fetchTemperatures()
        refreshControl.endRefreshing()
    }
    
    private func setupHomeView() {
        view.addSubview(tableViewScreen)
        tableViewScreen.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBarStyle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: Constants.blackColor
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.whiteColor
        ]
        title = Constants.title
        navigationController?.navigationBar.barTintColor = Constants.whiteColor
        
    }
    
    private func addKeyboardDismissTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        tableViewScreen.getSearchBar().endEditing(true)
    }
    
    private func fetchTemperatures() {
        cityTableViewModel.fetchTemperatures { [weak self] in
            DispatchQueue.main.async {
                self?.tableViewScreen.getTableView().reloadData()
            }
        }
    }
}

// MARK: - Constants
extension CityTableViewController {
    enum Constants {
        static let title: String = "Weather ⛅"
        static let blackColor: UIColor = .black
        static let whiteColor: UIColor = .white
    }
}

// MARK: - UITableViewDataSource
extension CityTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cityTableViewModel.filteredCities[indexPath.row]
        let model = DetailCityModel()
        let secondVM = DetailWeatherViewModel(detailCityModel: model, apiService: apiService, storageService: storageService, networkMonitor: networkMonitor)
        let secondVC = DetailWeatherViewController(viewModel: secondVM, cityName: city.name, homeLat: city.latitude, homeLon: city.longitude)
        secondVC.viewModel.onViewDidLoad(lat: city.latitude, lon: city.longitude)
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityTableViewModel.filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CityTableViewCell(style: .value1, reuseIdentifier: "CityCell")
        let city = cityTableViewModel.filteredCities[indexPath.row]
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.temperature
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension CityTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            cityTableViewModel.filteredCities = cityTableViewModel.cities
            tableViewScreen.getTableView().reloadData()
            return
        }

          cityTableViewModel.fetchSuggestions(query: searchText) { [weak self] in
            DispatchQueue.main.async {
                self?.tableViewScreen.getTableView().reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder()

        if cityTableViewModel.cities.contains(where: { $0.name.lowercased() == query.lowercased() }) {
            return
        }

        cityTableViewModel.apiService.fetchCityCoordinates(cityName: query) { [weak self] lat, lon in
            guard let self else { return }
            
            guard let lat, let lon else {
                DispatchQueue.main.async {
                    self.alertRouter.nothingWasFound()
                }
                return
            }
            
            let cityInfo = CityInfo(name: query, latitude: lat, longitude: lon)
            self.cityTableViewModel.addCity(with: cityInfo) {
                DispatchQueue.main.async {
                    self.tableViewScreen.getTableView().reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        cityTableViewModel.filteredCities = cityTableViewModel.cities
        tableViewScreen.getTableView().reloadData()
    }
}
