//
//  DeatailForecastTableViewCell.swift
//  MailWeather
//
//  Created by Maxim on 14.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import SnapKit

class DeatailForecastTableViewCell: UITableViewCell {
    private let dateLabel = UILabel()
    private let iconImageView = UIImageView()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()
    
    private let cellInset: CGFloat = 10
    private let dateLabelWidth: CGFloat = 150
    private let tempLabelWidth: CGFloat = 50
    private let iconWidth: CGFloat = 100
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = UIImage(named: "defaultWeatherImage")
    }
    
//    MARK:- Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBaseUI()
    }
    
//    MARK: - Setup UI
    private func setupBaseUI() {
        setupDateLabel()
    }
    
    private func setupDateLabel() {
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(cellInset)
            make.width.equalTo(dateLabelWidth)
        }
        setupIconImgView()
    }
    
    private func setupIconImgView() {
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(dateLabel.snp.trailing).inset(cellInset)
            make.height.width.equalTo(iconWidth)
        }
        setupMaxTempLabel()
    }
    
    private func setupMaxTempLabel() {
        self.addSubview(maxTempLabel)
        maxTempLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImageView.snp.trailing).offset(5 * cellInset)
            make.centerY.equalToSuperview()
            make.width.equalTo(tempLabelWidth)
        }
        setupMinTempLabel()
    }
    
    private func setupMinTempLabel() {
        self.addSubview(minTempLabel)
        minTempLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(maxTempLabel.snp.trailing).inset(cellInset)
            make.centerY.equalToSuperview()
            make.width.equalTo(tempLabelWidth)
        }
        
    }
//    MARK:- Configure
    func configure(date: String, icon: String, maxTem: String,
                   minTemp: String, cacheService: ImageCahceService) {
        setupImage(by: icon, with: cacheService)
        
        dateLabel.text = date
        maxTempLabel.text = maxTem
        minTempLabel.text = minTemp
        
        
    }
    
    private func setupImage(by icon: String, with chService: ImageCahceService) {
        let stringUrl = "https://openweathermap.org/img/w/\(icon).png"
        chService.getPhoto(by: stringUrl) {[weak self] (newImage) in
            guard let self = self else {return}
            self.iconImageView.image = newImage
        }
    }

}
