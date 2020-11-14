//
//  SearchService.swift
//  MailWeather
//
//  Created by Maxim on 13.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Moya
import RxSwift

protocol SearchServiceProtocol {
    func weatherSearch(town: String) -> Observable<WeatherModel>
    func searchForecast(town: String) -> Observable<ForecastWeatherModel>
}

final class SearchService: SearchServiceProtocol {
    private let provider = MoyaProvider<NetworkProvider>()
    private let queue = DispatchQueue.init(label: "serchWeaherQ")
    
    func weatherSearch(town: String) -> Observable<WeatherModel> {
        let token: NetworkProvider = .searchWeather(town: town)
        return provider.rx
            .request(token, callbackQueue: queue)
            .map(WeatherModel.self)
            .asObservable()
        
    }
    
    
    func searchForecast(town: String) -> Observable<ForecastWeatherModel> {
        let token: NetworkProvider = .getForecast(town: town)
        return provider.rx
            .request(token)
            .map(ForecastWeatherModel.self)
            .asObservable()
    }
}
