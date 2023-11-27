//
//  MainPresentor.swift
//  Pogoda
//
//  Created by macbook on 27.11.2023.
//

import UIKit
import CoreLocation

protocol WeatherViewProtocol: AnyObject {
    func updateWeather(with info: WeatherModel)
    func showError(with error: Error)
}

protocol WeatherProtocol: AnyObject {
    init(view: WeatherViewProtocol)
}

class MainPresentor: NSObject, WeatherProtocol {
    let view: WeatherViewProtocol!
    
    var weatherManager = WeatherMahager()
    var locationManager = CLLocationManager()
    
    required init(view: WeatherViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension MainPresentor: WeatherDelegate {
    func didUpdateWeather(_ weatherManager: WeatherMahager, weather: WeatherModel) {
        view?.updateWeather(with: weather)
    }
    
    func didFailWithError(error: Error) {
        view?.showError(with: error)
    }
    
    
}

extension MainPresentor: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Локация получена --->")
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Локация не была получена")
    }
}

