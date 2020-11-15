//
//  DetailWeatherViewModel.swift
//  MailWeather
//
//  Created by Maxim on 14.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//
import RxSwift

protocol DetailWeatherViewModelProtocol {
    var townNameSubject: BehaviorSubject<String> { get }
    var feelsLikeSubject: BehaviorSubject<String> { get }
    var weatherForecast: BehaviorSubject<[Forecast]> {get}
    
}

final class DetailWeatherViewModel: DetailWeatherViewModelProtocol {
    var townNameSubject: BehaviorSubject<String> = BehaviorSubject(value: "")
    var feelsLikeSubject: BehaviorSubject<String> = BehaviorSubject(value: "")
    var weatherForecast: BehaviorSubject<[Forecast]> = BehaviorSubject(value: [])
    
    
    private let router: DetailWeatherRouter
    private let service: SearchServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(router: DetailWeatherRouter, weather: WeatherModel,
         service: SearchServiceProtocol = SearchService()) {
        self.router = router
        self.service = service
        self.getForecast(by: weather.name)
        self.townNameSubject.onNext(weather.name)
        self.feelsLikeSubject.onNext(String(Int(round(weather.main.feelsLike))) + "℃")
    }
    
    private func getForecast(by town: String) {
        service.searchForecast(town: town)
            .subscribe(onNext: {[weak self] (newForecast) in
                guard let self = self else {return }
                self.weatherForecast.onNext(newForecast.items)
            })
            .disposed(by: disposeBag)
    }
}
