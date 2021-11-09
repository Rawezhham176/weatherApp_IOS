//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class WeatherViewController: UIViewController {

    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchtextfiled: UITextField!
    

    var weatherManager = WeatherManag()
    let locationManager = CLLocationManager()
    var video: String = "Clouds";

    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        weatherManager.delegate = self
        searchtextfiled.delegate = self
        
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    

}

//MARK: - UITextViewDelegate
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchtextfiled.text!)
        print("video: \(String(describing: self.video))")
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
            weatherManager.fetchWeather(cityname: city)
        }

        searchtextfiled.text = ""
    }
    
    
}


//MARK: - WeatherManagerDelagate
extension WeatherViewController: WeatherManagerDelagate{

    func didUpdateWeather(_ weatherManager: WeatherManag, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.video = weather.conditionName
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//MARK: - PlayVideo
extension WeatherViewController {
    
    func playVideo() {
        guard let path = Bundle.main.path(forResource: self.video , ofType: "mp4") else {
              return
          }
          
          let player = AVPlayer(url: URL(fileURLWithPath: path))
          let playerLayer = AVPlayerLayer(player: player)
          player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
          playerLayer.frame = self.view.bounds
          playerLayer.videoGravity = .resizeAspectFill
        
        
        self.videoLayer.layer.addSublayer(playerLayer)
        
        player.play()
        
        videoLayer.bringSubviewToFront(temperatureLabel)
        videoLayer.bringSubviewToFront(cityLabel)
        videoLayer.bringSubviewToFront(searchtextfiled)
        videoLayer.bringSubviewToFront(conditionImageView)
          
      }
    
    func videoResult() -> String{
        var video : String {
            switch self.video {
            case "cloud.bolt":
                return "Bolt"
            case "cloud.drizzle":
                return "Drizzle"
            case  "cloud.rain":
                return "Rain"
            case "cloud.snow":
                return "Snowfall"
            case "cloud.fog":
                return "Fog"
            case "sun.max":
                return "Clouds"
            case "cloud.bolt":
                return "Bolt"
            default:
                return "Clouds"
                    }
        }
        return ""
    }
    
}
