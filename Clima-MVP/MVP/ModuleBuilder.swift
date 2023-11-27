//
//  ModuleBuilder.swift
//  Pogoda
//
//  Created by macbook on 27.11.2023.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
}

class ModuleBuilder: Builder {
    static func createMainModule() -> UIViewController {
        let view = WeatherController()
        let presentor = MainPresentor(view: view)
        view.presenter = presentor
        return view
    }
    
    
}
