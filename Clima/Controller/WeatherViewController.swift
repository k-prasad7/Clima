//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
}

// MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        //        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        print("locationPressed!")
        locationManager.requestLocation()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // activates after textField is told to end editing.
        // clears the textField to a blank string
        // these textField funcs will be called by ANY textfield.
        // if you want to be  ambiguous use textField as it's passed
        //  in.
        // TODO use searchTextField to find weather. Then reset.
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city)
        }
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // asks should we end editing?
        // why trap user in editing mode? --> useful for doing validation on what was typed.
        // i.e. hit go to exit.
        if textField.text != ""{
            return true
        }
        else{
            textField.placeholder = "Type Something here!"
            return false
        }
    }
}

// MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ manager: WeatherManager, weather: WeatherModel){
        print(weather.conditionName)
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = "\(weather.temperatureString)"
            self.conditionImageView.image = UIImage(systemName:"\(weather.conditionName)")
        }
    }
    
    func didFailWithError(error: any Error) {
        print("Error: \(error)")
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    // Correct method signatures
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("Latitude: \(lat), Longtitude: \(lon)")
            weatherManager.fetchWeatherWithLatAndLon(lat, lon: lon)

        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    

}
