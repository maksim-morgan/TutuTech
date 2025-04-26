import UIKit

class HomeViewController: UIViewController, UITableViewDelegate {
    
    let homeView = HomeView()
    var homeViewModel = HomeViewModel()
    var apiService = ApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHomeView()
        setupNavigationBarStyle()
        addKeyboardDismissTap()
        fetchTemperatures()
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
        homeView.searchBar.delegate = self
    }
    
    private func setupHomeView() {
        view.addSubview(homeView)
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBarStyle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        title = "Weather ⛅"
        navigationController?.navigationBar.barTintColor = .white
        
    }
    
    private func addKeyboardDismissTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        homeView.searchBar.endEditing(true)
    }
    
    private func fetchTemperatures() {
        homeViewModel.fetchTemperatures { [weak self] in
            DispatchQueue.main.async {
                self?.homeView.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = homeViewModel.filteredCities[indexPath.row]
        let secondVM = SecondViewModel()
        let secondVC = SecondViewController(viewModel: secondVM, cityName: city.name)
        secondVC.setCoordinates(lat: city.latitude, lon: city.longitude)
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let city = homeViewModel.filteredCities[indexPath.row]
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.temperature
        cell.selectionStyle = .none
        return cell
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        homeViewModel.searchCities(query: searchText)
        homeView.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        
        if homeViewModel.cities.contains(where: { $0.name.lowercased() == query.lowercased() }) {
            return
        }
        
        homeViewModel.apiService.fetchCityCoordinates(cityName: query) { [weak self] lat, lon in
            guard let self else { return }
            
            guard let lat, let lon else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "City not found", message: "Please enter a valid city name.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
                return
            }
            
            self.homeViewModel.addCity(with: query, latitude: lat, longitude: lon) {
                DispatchQueue.main.async {
                    self.homeView.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        homeViewModel.filteredCities = homeViewModel.cities
        homeView.tableView.reloadData()
    }
}
