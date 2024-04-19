//
//  WeatherModel.swift
//  Clima
//
//  Created by Kiran Prasad on 3/29/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    // computed property
    var conditionName: String {
         switch conditionId {
         case 200..<300:
             return "cloud.bolt.rain"
         case 300..<400:
             return "cloud.drizzle"
         case 500..<600:
             return "cloud.rain"
         case 600..<700:
             return "cloud.snow"
         case 700..<800:
             return "smoke" // mist, smoke, haze, etc.
         case 800:
             return "sun.max"
         case 801...899:
             return "cloud"
         default:
             return "cloud"
         }
    }
}
