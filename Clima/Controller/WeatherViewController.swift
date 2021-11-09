//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelagate {

    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchtextfiled: UITextField!

    var weatherManager = WeatherManag()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchtextfiled.delegate = self

    }

    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchtextfiled.text!)
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchtextfiled.text!)
        searchtextfiled.endEditing(true)
        return true

    }



    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchtextfiled.text != "" {
            return true
        } else {
            textField.placeholder = "Type something!"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchtextfiled.text {
            weatherManager.fetchData(cityname: city)
        }

        searchtextfiled.text = ""
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        print(weather.cityName)
    }
}

