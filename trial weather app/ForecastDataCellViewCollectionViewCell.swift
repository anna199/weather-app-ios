//
//  ForecastDataCellViewCollectionViewCell.swift
//  trial weather app
//
//  Created by Laura Zhou on 11/29/17.
//  Copyright © 2017 Ran Li. All rights reserved.
//

import UIKit

class ForecastDataCellViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
//    public var cellData:OpenWeatherMapData? {
//        didSet{
////            timeLabel.text = getTime()
////            statusLabel.text = getWeatherConditions()
////            temperatureLabel.text = getTemperatureRange()
//            timeLabel.text = "aaatime"
//            statusLabel.text = "bbbstatus"
//            temperatureLabel.text = "ccctemp"
//        }
//    }
    
    public override func awakeFromNib() {
//        timeLabel.text = "-"
//        statusLabel.text = "--"
//        temperatureLabel.text = "--/--"
        
        
        timeLabel.text = "a"
        statusLabel.text = "b"
        temperatureLabel.text = "c"
//        self.contentView.autoresizingMask =
//            [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
    }
    
//    private func getTime()->String{
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "hh:mm a"
//        if let day = cellData?.dateTimeUtc{
//            return timeFormatter.stringFromDate(day)
//        }
//        return "--"
//    }
    
//    private func getTemperatureRange()->String{
//        var temperatureText = "--"
//        if let temp = cellData?.minTemperature{
//            temperatureText =
//            "\(NSString(format:"%.2f", TemperatureConverter.ToCelcius(kelvin:temp)))"
//        }
//        else{
//            if let temp = cellData?.maxTemperature{
//                temperatureText +=
//                "\(NSString(format:"%.2f", TemperatureConverter.ToCelcius(kelvin:temp)))"
//            }
//        }
//        return temperatureText+"℃"
//    }
//    private func getWeatherConditions()->String{
//        if let conditions = cellData?.weatherConditions{
//            var conditionText = ""
//            for condition in conditions{
//                conditionText = "\(condition.weatherCondition!)"
//            }
//            return conditionText
//        }
//        return "--"
//    }
}
