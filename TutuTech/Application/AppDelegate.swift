//
//  AppDelegate.swift
//  TutuTech
//
//  Created by Mrmaks on 13.04.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let apiService = ApiService()
        let storageService = StorageService()
        let networkMonitor = NetworkMonitor()
        let router = AlertRouter()
        let viewModel = CityTableViewModel(apiService: apiService, storageService: storageService, networkMonitor: networkMonitor, router: router)
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: CityTableViewController(cityTableViewModel: viewModel, alertRouter: router))
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

