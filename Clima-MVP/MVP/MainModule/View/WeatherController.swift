//
//  WeatherController.swift
//  Clima
//
//  Created by macbook on 23.11.2023.
//

import UIKit
import CoreLocation

class WeatherController: UIViewController {
    
    private let searchView = SearchView()
    private let infoView = InfoView()

    
    var presenter: MainPresentor!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        addTargets()
        searchView.textField.delegate = self
        
        presenter = MainPresentor(view: self)
        
        presenter.weatherManager.delegate = presenter
        presenter.locationManager.delegate = presenter
        presenter.viewDidLoad()

        
        
    }
    
    private func setupView() {
        
        view.addSubViews(searchView, infoView)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        searchView.isUserInteractionEnabled = true
        
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            infoView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 50),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    private func addTargets() {
        searchView.searchButtonTarget(self, action: #selector(searchAction))
        searchView.locationTarget(self, action: #selector(locationAction))
    }
    
    
    @objc private func searchAction() {
        searchView.endEditing()
    }
    
    @objc func locationAction() {
        DispatchQueue.main.async {
            self.presenter.locationManager.requestLocation()
        }
        
    }
    
}


//MARK: - TextFieldDelegate
extension WeatherController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            presenter.weatherManager.fetchWeather(cityName: city)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            searchView.updatePlaceholder("Add city!")
            return false
        }
    }
}


extension WeatherController: WeatherViewProtocol {
    func updateWeather(with info: WeatherModel) {
        DispatchQueue.main.async {
            self.infoView.updateCityText(for: info.cityName)
            self.infoView.updateNumberLabel(for: info.temperatureString)
            self.infoView.updateSunImage(for: info.conditionName)
        }
    }
    
    func showError(with error: Error) {
        print(error)
    }
    
    
}
//MARK: - SwiftUI
import SwiftUI
struct Provider_WeatherController : PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return WeatherController()
        }
        
        typealias UIViewControllerType = UIViewController
        
        
        let viewController = WeatherController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<Provider_WeatherController.ContainterView>) -> WeatherController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: Provider_WeatherController.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<Provider_WeatherController.ContainterView>) {
            
        }
    }
    
}
