//
//  WeatherManager.swift
//  Clima
//
//  Created by Kiran Prasad on 3/29/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ manager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b0c72dd61d9ff266cd87da961dc3a501&units=imperial"
    
    func fetchWeather(_ cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeatherWithLatAndLon(_ lat: Double, lon: Double){
        let urlString = "\(weatherURL)&lat=\(String(lat))&lon=\(String(lon))"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //since it's created from a string, it creates
        //  an optional URL.
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weatherModel = self.parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather:weatherModel)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data)-> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            guard let firstWeather = decodedData.weather.first else {
                print("Weather data is missing.")
                return nil
            }
            let weatherModel = WeatherModel(
                conditionId: firstWeather.id,
                cityName: decodedData.name,
                temperature: decodedData.main.temp
            )
            print("WeatherModel.conditionName: \(weatherModel.conditionName)")
            print("WeatherModel.temp: \(weatherModel.temperature)")
            return weatherModel
        } catch {
            print("Error with decoding JSON: \(error)")
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
