//
//  DetailWeatherViewController.swift
//  MailWeather
//
//  Created by Maxim on 14.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DetailWeatherViewController: UIViewController {
//    ViewModel
    var detailVM: DetailWeatherViewModelProtocol!
//    Views
    private let headerView = HeaderView()
    private let forecastTableView = UITableView()
    
// Forecst items
    private var items: [Forecast] = [] {
        didSet {
            forecastTableView.reloadData()
        }
    }
    
//    MARK:- Chache Services
    private var dateCache = [IndexPath: String]()
    private let imageCacheService = ImageCahceService()
    
//    MARK: DateFormater
    private let dateFormater: DateFormatter = {
        let dateForm = DateFormatter()
        dateForm.dateFormat = "EEEE, HH:mm"
        return dateForm
    }()
    
//    Consts
    private let headerHeight: CGFloat = 130
    private let cellHeight: CGFloat = 80
    
//    MARK:- RxStuff
    private let disposeBag = DisposeBag()
    

//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        setupUI()
        binding()
        loadData()
        
    }
    
//    MARK: Setup UI
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(forecastTableView)
        forecastTableView.register(DeatailForecastTableViewCell.self, forCellReuseIdentifier: DeatailForecastTableViewCell.reuseIdentifire)
        forecastTableView.snp.makeConstraints({$0.edges.equalToSuperview()})
    }
    
//    MARK: - Binding
    private func binding() {
        detailVM.townNameSubject
            .bind(to: headerView.townNameLabel.rx.text)
            .disposed(by: disposeBag)

        detailVM.feelsLikeSubject
            .bind(to: headerView.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        detailVM.weatherForecast
            .subscribe(onNext: {[weak self] (newForecast) in
                guard let self = self else {return }
                self.items = newForecast
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - TableView Delegate
extension DetailWeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.backgroundColor = .white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK:- TableView DataSource
extension DetailWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let forecast = items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeatailForecastTableViewCell.reuseIdentifire, for: indexPath) as? DeatailForecastTableViewCell else {fatalError("{Error: dequeud Cell")}
    
        
        guard let icon = forecast.weather.first?.icon else {return UITableViewCell()}
        let cacheStringDate = getCacheDate(by: indexPath, forecast: forecast)
        cell.configure(date: cacheStringDate, icon: icon,
                       maxTem: getTemp(temp: forecast.main.tempMax),
                       minTemp: getTemp(temp: forecast.main.tempMin),
                       cacheService: imageCacheService)
        return cell
    }
    private func getCacheDate(by indexPath: IndexPath, forecast: Forecast) -> String {
        if let cachedStr = dateCache[indexPath] {
            return cachedStr
        } else {
            let dateString = getDay(date: forecast.dt)
            dateCache[indexPath] = dateString
            return dateString
        }
        
    }
    private func getDay(date: Int) -> String {
        return dateFormater.string(from: Date(timeIntervalSince1970: TimeInterval(date)))
    }
    
    private func getTemp(temp: Double) -> String {
        return String(Int(round(temp)))
        
    }
    
}
