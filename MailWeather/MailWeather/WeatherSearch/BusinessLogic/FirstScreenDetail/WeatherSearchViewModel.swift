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
    
    private var weather = [WeatherModel]()
    
    private let recommendationText = "Input Correct Town..."
    
//    MARK:- Init
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
                self.responseTownNameSubject.onNext(self.recommendationText)
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
                self.weather = [weather]
                self.responseTownNameSubject.onNext(weather.name)
                self.responseIconSubject.onNext(weather.weather.first?.icon ?? "")
                self.responseTemperatureSubject.onNext(String(Int(round(weather.main.temp))) + "℃")
            })
            .disposed(by: disposeBag)
    }
    
//    MARK:- Router Work
    private func showDetailWeatherScreen() {
        isTap
            .filter({$0})
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return }
                guard let weather = self.weather.first else {return }
                self.router.showDetailWeatherScreen(weather: weather)
            })
            .disposed(by: disposeBag)
    }
}
