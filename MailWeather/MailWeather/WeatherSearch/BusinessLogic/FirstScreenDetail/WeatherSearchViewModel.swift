import RxSwift

protocol WeatherSearchViewModelProtocol {
    var searchTextSubject: BehaviorSubject<String> { get }
    
    var responseTownNameSubject: BehaviorSubject<String> { get }
    var responseIconSubject: BehaviorSubject<String> { get }
    var responseTemperatureSubject: BehaviorSubject<String> { get }
    
    var isTap: BehaviorSubject<Bool> { get }
    
}

final class WeatherSearchViewModel: WeatherSearchViewModelProtocol {
    var searchTextSubject: BehaviorSubject<String> = BehaviorSubject(value: "")
    var responseTownNameSubject: BehaviorSubject<String> = BehaviorSubject(value: "")
    var responseIconSubject: BehaviorSubject<String> = BehaviorSubject(value: "")
    var responseTemperatureSubject: BehaviorSubject<String> = BehaviorSubject(value: "")
    var isTap: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let router: WeatherSearchRouter
    private let service: SearchServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(router: WeatherSearchRouter, service: SearchServiceProtocol = SearchService() ) {
        self.router = router
        self.service = service
        changeValue()
        showDetailWeatherScreen()
    }
    
    private func changeValue() {
        searchTextSubject
            .throttle(0.4, scheduler: MainScheduler.asyncInstance)
            .do(onNext: {[weak self] (_) in
                guard let self = self else {return }
                self.responseTownNameSubject.onNext("Input correct town... ")
                self.responseIconSubject.onNext("")
                self.responseTemperatureSubject.onNext("")
            })
            .subscribe(onNext: {[weak self] (userRequest) in
                guard let self = self else {return }
                self.searchWeather(town: userRequest)
            })
            .disposed(by: disposeBag)
    }
    
    private func searchWeather(town: String) {
        service
            .weatherSearch(town: town)
            .subscribe(onNext: {[weak self] (weather) in
                guard let self = self else {return }
                self.responseTownNameSubject.onNext(weather.name)
                self.responseIconSubject.onNext(weather.weather.first?.icon ?? "")
                self.responseTemperatureSubject.onNext(String(Int(round(weather.main.temp))))
            })
            .disposed(by: disposeBag)
    }
    
    private func showDetailWeatherScreen() {
        isTap
            .filter({$0})
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return }
                self.router.showDetailWeatherScreen()
            })
            .disposed(by: disposeBag)
    }
}
