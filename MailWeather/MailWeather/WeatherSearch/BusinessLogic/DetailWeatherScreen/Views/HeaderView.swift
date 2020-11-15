//
//  HeaderView.swift
//  MailWeather
//
//  Created by Maxim on 14.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    let townNameLabel = UILabel()
    let infoLabel = UILabel()
    let temperatureLabel = UILabel()
    
    private let viewInset: CGFloat = 5
    private let townNameHeight: CGFloat = 50
    private let infoText = "Feels like:"
    
    //    MARK:- Init
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupBaseUI()
            setLabel()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    //    MARK: - Setup UI
        private func setupBaseUI() {
            setupTextLabels()
            setupTemperatureLabel()
        }
    
    private func setupTextLabels() {
        self.addSubview(townNameLabel)
        self.addSubview(infoLabel)
        townNameLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().inset(viewInset)
            make.height.equalTo(townNameHeight)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(townNameLabel.snp.bottom).inset(viewInset)
            make.centerX.equalTo(townNameLabel.snp.centerX)
            make.height.equalTo(townNameHeight / 2)
        }
    }
    
    private func setupTemperatureLabel() {
        self.addSubview(temperatureLabel)
        
        temperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(2 * viewInset)
            make.centerX.equalTo(townNameLabel.snp.centerX)
            make.height.equalTo(townNameHeight / 2)
        }
    }
    
    private func setLabel() {
        townNameLabel.textAlignment = .center
        townNameLabel.font = UIFont.systemFont(ofSize: 27)
        
        infoLabel.textAlignment = .center
        infoLabel.text = infoText
        
        temperatureLabel.font = UIFont.systemFont(ofSize: 30)
    }
}
