import Foundation

struct WeatherManag {
    let wetherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=1fe3ea8fe115a48cca9d284045518089&units=metric"

    func fetchData(cityname: String) {
        let urlString = "\(wetherUrl)&q=\(cityname)"
    }

    func peformRequest(urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))

            task.resume()
        }
    }

        func handle(data: Data?, response: URLResponse?, error: Error?){
            if error != nil {
                print(error)
                return
        }

        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        }
    }
}
