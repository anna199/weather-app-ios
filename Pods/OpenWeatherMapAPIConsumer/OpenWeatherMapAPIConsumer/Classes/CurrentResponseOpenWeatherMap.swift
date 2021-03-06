 //
//  ResponseOpenWeatherMap.swift
//  WhatWearToday
//
//  Created by jlcardosa on 17/11/2016.
//  Copyright © 2016 Cardosa. All rights reserved.
//

import Foundation
import CoreLocation


public class CurrentResponseOpenWeatherMap : ResponseOpenWeatherMap, ResponseOpenWeatherMapProtocol {
	
	
	public func getCoord() -> CLLocationCoordinate2D {
		let coord = self.rawData["coord"] as! Dictionary<String,Float>
		return CLLocationCoordinate2D(latitude: CLLocationDegrees(coord["lat"]!), longitude: CLLocationDegrees(coord["long"]!))
	}
	
    public func getTemperature() -> Float {
        let main = self.getDictionary(byKey: "main")
        return main["temp"] as! Float
    }
	
    public func getPressure() -> Float {
		let main = self.getDictionary(byKey: "main")
        return main["pressure"] as! Float
    }
    
    public func getHumidity() -> Float {
		let main = self.getDictionary(byKey: "main")
        return main["humidity"] as! Float
    }
    
    public func getTempMax() -> Float {
		let main = self.getDictionary(byKey: "main")
        return main["temp_max"] as! Float
    }
    
    public func getTempMin() -> Float {
		let main = self.getDictionary(byKey: "main")
        return main["temp_min"] as! Float
    }
    
    public func getCityName() -> String {
        return self.rawData["name"] as! String
    }
    
    public func getItemsForDetail() -> [String] {
        var items : [String] = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
        let list = self.rawData["list"] as! NSArray
        
        for i in 0...7 {
            let hourData = list[i] as! NSDictionary
            let statusObj = hourData["weather"] as! NSArray
            let array0 = statusObj[0] as! NSDictionary
            let status = array0["description"] as! String
            
            if status.lowercased().range(of:"cloud") != nil {
                items[i] = "Cloudy"
            } else if (status.lowercased().range(of:"clear") != nil) {
                items[i] = "Sunny"
            } else if (status.lowercased().range(of:"rain") != nil) {
                items[i] = "Rainy"
            } else if (status.lowercased().range(of:"dust") != nil) {
                items[i] = "Dusty"
            }else {
                items[i] = status
            }
        }

        for i in 0...7 {
            let hourData = list[i] as! NSDictionary
            let tempObj = hourData["main"] as! NSDictionary
            let temp = Int(tempObj["temp"] as! NSNumber)
            
            items[i + 8] = String(temp) + "°"
        }
        return items
    }
    
    // only get "status", "max", "min" for each day
    // will insert date in the future
    public func getDayItemsForDetail() -> [String] {
        var dayItems : [String] = ["", "", "",
                                 "", "", "",
                                 "", "", "",
                                 "", "", ""]
        
        let list = self.rawData["list"] as! NSArray
        
        let cntPerDayHalf = list.count / 4 / 2
        
        for i in 0...3 {
            let dayData = list[i + cntPerDayHalf] as! NSDictionary
            let statusObj = dayData["weather"] as! NSArray
            let array0 = statusObj[0] as! NSDictionary
            let status = array0["description"] as! String
            
            if status.lowercased().range(of:"cloud") != nil {
                dayItems[i * 3] = "Cloudy"
            } else if (status.lowercased().range(of:"clear") != nil) {
                dayItems[i * 3] = "Sunny"
            } else if (status.lowercased().range(of:"rain") != nil) {
                dayItems[i * 3] = "Rainy"
            } else if (status.lowercased().range(of:"dust") != nil) {
                dayItems[i * 3] = "Dusty"
            } else {
                dayItems[i * 3] = status
            }
            
            let mainObj = dayData["main"] as! NSDictionary
            var maxTemp = Int(truncating: mainObj["temp_max"] as! NSNumber)
            if (maxTemp % 2 == 0) {
                maxTemp = maxTemp + 2
            }
            let minTemp = Int(truncating: mainObj["temp_min"] as! NSNumber) - 1
            dayItems[i * 3 + 1] = String(maxTemp) + "°"
            dayItems[i * 3 + 2] = String(minTemp) + "°"
        }
        
        
        return dayItems
    }
    
	
	public func getIconList() -> IconList {
		let weather = self.getArrayOfDictionary(byKey: "weather").first
		let icon = weather?["icon"] as! String
		return IconList(rawValue: icon)!
	}
    
	public func getDescription() -> String {
		let weather = self.getArrayOfDictionary(byKey: "weather").first
		return weather?["description"] as! String
    }
    
    public func getWindSpeed() -> Float {
		let wind = self.getDictionary(byKey: "wind")
        return wind["speed"] as! Float
    }
    
    public func getDate() -> Date {
        return Date(timeIntervalSince1970: self.rawData["dt"] as! TimeInterval)
    }
}
