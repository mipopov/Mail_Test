//
//  ForecastWeatherModel.swift
//  MailWeather
//
//  Created by Maxim on 14.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

// MARK: - ForecastWeatherModel
struct ForecastWeatherModel: Decodable {
    let items: [Forecast]
    
    enum CodingKeys: String, CodingKey {
        case items = "list"
    }
}

// MARK: - Item
struct Forecast: Decodable {
    let dt: Int
    let main: MainWeatherInfo
    let weather: [WeatherIconModel]

}
