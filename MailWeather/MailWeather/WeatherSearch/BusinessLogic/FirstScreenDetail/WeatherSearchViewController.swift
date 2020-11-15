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
    private let backGroundImageView = UIImageView()
    private let weatherView = WeatherView()
//    Consts
    private let viewWidth: CGFloat = 280
    private let viewHeight: CGFloat = 200
    private let searchBarPlaceholder = "Enter town ..."
    private let recommendationText = "Input Correct Town..."
    
    private let viewOffset: CGFloat = 10
    
//  MARK: - RxStuff
    private let disposeBag = DisposeBag()
    
//  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchbar.text = ""
        searchVM.responseIconSubject.onNext("")
        searchVM.responseTemperatureSubject.onNext("")
        searchVM.responseTownNameSubject.onNext(recommendationText)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
//  MARK: - Setup UI
    private func setupUI() {
        setupBackGround()
        setupSearchBar()
        setupView()
    }
    
    private func setupSearchBar() {
        searchbar.searchBarStyle = .minimal
        searchbar.placeholder = searchBarPlaceholder
        navigationItem.titleView = searchbar
    }
    
    private func setupBackGround(){
        view.addSubview(backGroundImageView)
        backGroundImageView.snp.makeConstraints({$0.leading.trailing.top.bottom.equalToSuperview()})
        backGroundImageView.image = UIImage(named: "backGround")
    }
    
    private func setupView() {
        view.addSubview(weatherView)
        weatherView.backgroundColor = UIColor.lightWhite
        weatherView.snp.makeConstraints { (make) in
            make.top.equalTo(searchbar.snp.bottom).offset(viewOffset)
            make.centerX.equalToSuperview()
            make.width.equalTo(viewWidth)
            make.height.equalTo(viewHeight)
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
            .filter({$0.count > 1})
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

