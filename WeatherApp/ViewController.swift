//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mark Kim on 6/5/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        renderApi()
    }
    
    func renderApi() {
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?zip=94108,us&units=imperial&appid=13087470b7be46fd21cedb37426d2a9f") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                    guard let weatherDetails = json["weather"] as? [[String: Any]], let weatherMain = json["main"] as? [String: Any] else { return }
                    let temp = Int(weatherMain["temp"] as? Double ?? 0)
                    let description = (weatherDetails.first?["description"] as? String)?.capitalizingFirstLetter()
                    DispatchQueue.main.async {
                        self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp: temp)
                    }
                } catch {
                    print("error")
                }
            }
        }
        task.resume()
    }
    
    func setWeather(weather: String?, description: String?, temp: Int) {
        weatherDescriptionLabel.text = description ?? "look outside and you tell me"
        tempLabel.text = "\(temp)°"
        switch weather {
        case "Sunny":
            weatherImageView.image = UIImage(named: "sunny100")
            background.backgroundColor = UIColor(red: 0.97, green: 0.78, blue: 0.35, alpha: 1.0)
        default:
            weatherImageView.image = UIImage(named: "rain100")
            background.backgroundColor = .blue
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

