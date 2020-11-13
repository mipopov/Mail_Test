//
//  WeatherSearchViewController.swift
//  MailWeather
//
//  Created by Maxim on 13.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Kingfisher

final class WeatherSearchViewController: UIViewController {
//    View Model
    var searchVM: WeatherSearchViewModelProtocol!
    
//    Views
    private let searchbar = UISearchBar()
    private let weatherView = WeatherView()
//    Consts
    private let viewHeightWidth: CGFloat = 250
    private let searchBarPlaceholder = "Введите название города..."
    
//    RxStuff
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        binding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        setupSearchBar()
        setupView()
        
    }
//    MARK: - Search Bar
    private func setupSearchBar() {
        searchbar.searchBarStyle = .minimal
        searchbar.placeholder = searchBarPlaceholder
        navigationItem.titleView = searchbar
    }
//    MARK: - Views
    private func setupView() {
        view.addSubview(weatherView)
        weatherView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(viewHeightWidth)
        }
    }
//    MARK:- Binding
    private func binding(){
        bindingSearchBar()
        bindingLabels()
        bindingImage()
        isTapBinding()
    }
    
    private func bindingSearchBar() {
        searchbar.rx.text
            .orEmpty
            .asObservable()
            .bind(to: searchVM.searchTextSubject)
            .disposed(by: disposeBag)
    }
    private func bindingLabels() {
        searchVM.responseTownNameSubject
            .bind(to: weatherView.townNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        searchVM.responseTemperatureSubject
            .bind(to: weatherView.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
    }
    private func bindingImage() {
        searchVM.responseIconSubject
            .map({URL(string: "https://openweathermap.org/img/w/\($0).png")})
            .subscribe(onNext: {[weak self] (new_url) in
                guard let self = self else {return }
                DispatchQueue.main.async {
                    self.weatherView.weatherIconImageView.kf.setImage(with: new_url)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func isTapBinding() {
        let isTap = weatherView.rx
            .tapGesture()
            .asObservable()
        
        Observable
            .combineLatest(searchVM.responseTemperatureSubject, isTap)
            .filter({$0.0.count > 0 && $0.1.state == .ended})
            .map({_ in true})
            .bind(to: searchVM.isTap)
            .disposed(by: disposeBag)
    }
}