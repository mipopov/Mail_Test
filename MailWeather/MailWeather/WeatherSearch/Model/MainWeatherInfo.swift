//
//  MainWeatherInfo.swift
//  MailWeather
//
//  Created by Maxim on 14.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation


struct MainWeatherInfo: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
