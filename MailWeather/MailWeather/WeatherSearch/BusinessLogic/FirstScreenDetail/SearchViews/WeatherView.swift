//
//  WeatherView.swift
//  MailWeather
//
//  Created by Maxim on 13.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import SnapKit

class WeatherView: UIView {
    let townNameLabel = UILabel()
    let weatherIconImageView = UIImageView()
    let temperatureLabel = UILabel()
    
    private let viewInset: CGFloat = 5
    private let townLabelHeight: CGFloat = 50
    private let imgHeightWidth: CGFloat = 150
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseUI()
        setFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBaseUI() {
        setupTownLabel()
        
    }
    private func setupTownLabel() {
        self.addSubview(townNameLabel)
        townNameLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(viewInset)
            make.height.equalTo(townLabelHeight)
        }
        setupImageView()
    }
    
    private func setupImageView() {
        self.addSubview(weatherIconImageView)
        weatherIconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(townNameLabel.snp.bottom).inset(viewInset)
            make.leading.equalToSuperview().inset(viewInset)
            make.width.height.equalTo(imgHeightWidth)
        }
        setupTemperatureLabel()
    }
    
    private func setupTemperatureLabel() {
        self.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(townNameLabel.snp.bottom).inset(viewInset)
            make.leading.equalTo(weatherIconImageView.snp.trailing).offset(viewInset)
            make.height.width.equalTo(imgHeightWidth)
        }
    }
    
    private func setFields() {
        townNameLabel.textAlignment = .center
        townNameLabel.font = UIFont.systemFont(ofSize: 25)
        
        temperatureLabel.font = UIFont.systemFont(ofSize: 25)
        temperatureLabel.textAlignment = .center
        
        weatherIconImageView.contentMode = .scaleAspectFill
    }
}
