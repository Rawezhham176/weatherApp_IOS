import Foundation
import CoreLocation

protocol WeatherManagerDelagate {
    func didUpdateWeather(_ weatherManager: WeatherManag, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManag {
    let wetherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=1fe3ea8fe115a48cca9d284045518089&units=metric"
    
    var delegate : WeatherManagerDelagate?

    func fetchWeather(cityname: String) {
        let urlString = "\(wetherUrl)&q=\(cityname)"
        peformRequest(with: urlString)
    }

    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let urlString = "\(wetherUrl)&lat=\(lat)&lon=\(lon)"
        peformRequest(with: urlString)
    }

    func peformRequest(with urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { data, respobse, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                        return
                }

                if let safeData = data {
                    //  let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJson(wetherData: safeData) {
                        delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
            }

            task.resume()
        }
    }
    
    
    func parseJson(wetherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try  decoder.decode(WeatherData.self, from: wetherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name!
            let temp = decodedData.main.temp
            
            let weathermodel = WeatherModel(cityName: name, conditionId: id, temperature: temp)
            
            return weathermodel
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
       
    } 
    
    

}
