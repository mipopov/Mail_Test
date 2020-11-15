//
//  NetworkProvider.swift
//  MailWeather
//
//  Created by Maxim on 13.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Moya

enum NetworkProvider: TargetType {
    case searchWeather(town: String)
    case getForecast(town: String)
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/")!
    }
    
    var path: String {
        switch self {
        case .searchWeather:
            return "data/2.5/weather"
        case .getForecast:
            return "data/2.5/forecast"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            
        case let .searchWeather(town: town):
            let params = ["q": town, "appid": "df517298ffb39fe22b47b4747b0c7f66", "units": "metric"]
            return .requestParameters(parameters: params, encoding: URLEncoding())
            
        case let .getForecast(town: town):
            let params =  ["q": town, "appid":"df517298ffb39fe22b47b4747b0c7f66", "units": "metric", "cnt": "10"]
            return .requestParameters(parameters: params, encoding: URLEncoding())
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
