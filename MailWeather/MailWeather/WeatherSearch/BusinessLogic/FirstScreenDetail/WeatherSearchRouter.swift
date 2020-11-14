final class WeatherSearchRouter: BaseRouter {
    func showDetailWeatherScreen(weather: WeatherModel) {
        let detailVC = DetailWeatherViewController()
        let router = DetailWeatherRouter(viewController: detailVC)
        detailVC.detailVM = DetailWeatherViewModel(router: router, weather: weather)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
