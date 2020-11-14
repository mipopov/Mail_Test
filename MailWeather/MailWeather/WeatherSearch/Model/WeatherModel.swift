//
//  WeatherModel.swift
//  MailWeather
//
//  Created by Maxim on 13.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

struct WeatherModel: Decodable {
    let weather: [WeatherIconModel]
    let main: MainWeatherInfo
    let name: String
}
