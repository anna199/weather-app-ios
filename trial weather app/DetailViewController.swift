//
//  DetailViewController.swift
//  trial weather app
//
//  Created by Laura Zhou on 11/30/17.
//  Copyright © 2017 Ran Li. All rights reserved.
//

import UIKit
import OpenWeatherMapAPIConsumer

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var hourCollectionView: UICollectionView!
    @IBOutlet weak var dayCollectionView: UICollectionView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityStatusLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxMinTempLabel: UILabel!
    
    var weatherAPI : OpenWeatherMapAPI!
    var apiKey : String!
    var responseWeatherApi : ResponseOpenWeatherMapProtocol!

    var items : [String] = []
    var dayItems : [String] = []
    var city: City = City(name: "San Jose, CA, United States", lat: "37.3382082", lon: "-121.8863286")!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameLabel.text = city.name
        
        let dateFormatterForDetail = DateFormatter()
        dateFormatterForDetail.timeZone = NSTimeZone(name: (city.timeZoneId))! as TimeZone
        dateFormatterForDetail.dateFormat = "EEE, MMM d, y"
        dateLabel.text = dateFormatterForDetail.string(from : Date())
        
        dateFormatterForDetail.dateFormat = "HH"
        let curHour : String = dateFormatterForDetail.string(from : Date())
        
        for i in 0...7 {
            let tmp = Int(curHour)
            let tmpHour = (tmp! + 3 * i) % 24
            if(tmpHour >= 12) {
                items.append(String(tmpHour) + " PM")
            } else {
                items.append(String(tmpHour) + " AM")
            }
        }
        
        apiKey = "b4631e5c54e1a3a9fdda89fca90d4114"
        weatherAPI = OpenWeatherMapAPI(apiKey: self.apiKey, forType: OpenWeatherMapType.Current)
        weatherAPI.setTemperatureUnit(unit: TemperatureFormat.Celsius)
        
        setCurrentTemp()
        
        self.items += prepareItems()
        self.dayItems += prepareDayItems()
     
        hourCollectionView.delegate = self
        hourCollectionView.dataSource = self
        hourCollectionView.backgroundColor = UIColor.clear
        
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.backgroundColor = UIColor.clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }


    func prepareItems() ->[String] {
        weatherAPI = OpenWeatherMapAPI(apiKey: "b4631e5c54e1a3a9fdda89fca90d4114", forType: OpenWeatherMapType.Forecast)
        weatherAPI.setTemperatureUnit(unit: TemperatureFormat.Celsius)
        weatherAPI.weather(byLatitude: Double(city.lat)!, andLongitude: Double(city.lon)!)
        let group = DispatchGroup()
        group.enter()
        
        var item : [String] =  []
        weatherAPI.performWeatherRequest(completionHandler:{(data: Data?, urlResponse: URLResponse?, error: Error?) in
            if (error != nil) {
                print("error1")
                //Handling error
            } else {
                do {
                    let responseWeatherApi = try CurrentResponseOpenWeatherMap(data: data!)
                    let tmp = responseWeatherApi.getItemsForDetail()
               
                    item = tmp
                    
                    group.leave()
                    
                } catch let error as Error {
                    //Handling error
                    print("error2")
                }
            }
        })
     
        group.wait()
        return item
        
    }
    
    func prepareDayItems() -> [String] {
        weatherAPI = OpenWeatherMapAPI(apiKey: "b4631e5c54e1a3a9fdda89fca90d4114", forType: OpenWeatherMapType.Forecast)
        weatherAPI.setTemperatureUnit(unit: TemperatureFormat.Celsius)
        weatherAPI.weather(byLatitude: Double(city.lat)!, andLongitude: Double(city.lon)!)
        let group = DispatchGroup()
        group.enter()
        var dayItem : [String] =  []
        weatherAPI.performWeatherRequest(completionHandler:{(data: Data?, urlResponse: URLResponse?, error: Error?) in
            if (error != nil) {
                print("error3")
                //Handling error
            } else {
                do {
                let responseWeatherApi = try CurrentResponseOpenWeatherMap(data: data!)
                    let tmp = responseWeatherApi.getDayItemsForDetail()
                    
                    let dateFormatterForDetail = DateFormatter()
                    dateFormatterForDetail.timeZone = NSTimeZone(name: (self.city.timeZoneId))! as TimeZone
                    dateFormatterForDetail.dateFormat = "EEE"
                    
                    let today = Date()
                    let day1 : Date = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                    let day2 : Date = Calendar.current.date(byAdding: .day, value: 2, to: today)!
                    let day3 : Date = Calendar.current.date(byAdding: .day, value: 3, to: today)!
                    let day4 : Date = Calendar.current.date(byAdding: .day, value: 4, to: today)!
                    let day5 : Date = Calendar.current.date(byAdding: .day, value: 5, to: today)!
                    
                    let day1Date = dateFormatterForDetail.string(from : day1)
                    let day2Date = dateFormatterForDetail.string(from : day2)
                    let day3Date = dateFormatterForDetail.string(from : day3)
                    let day4Date = dateFormatterForDetail.string(from : day4)
                    let day5Date = dateFormatterForDetail.string(from : day5)
                    
                    dayItem = tmp
                    dayItem.insert(day1Date, at: 0)
                    dayItem.insert(day2Date, at: 4)
                    dayItem.insert(day3Date, at: 8)
                    dayItem.insert(day4Date, at: 12)
                    dayItem.insert(day5Date, at: 16)
                    
                    group.leave()
            
                } catch let error as Error {
                //Handling error
                    print("error4")
                }
            }
        })
    
    
        group.wait()
        return dayItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.hourCollectionView) {
            return self.items.count / 3
        } else {
            return self.dayItems.count / 4
        }        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        
        if (collectionView == self.hourCollectionView) {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath as IndexPath) as! ForecastDataCellViewCollectionViewCell


            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.timeLabel.text = self.items[indexPath.item]
            cell.statusLabel.text = self.items[indexPath.item + 8]
            cell.temperatureLabel.text = self.items[indexPath.item + 16]
            
            return cell
        } else{

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath as IndexPath) as! DayForecastCollectionViewCell

            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.dayLabel.text = self.dayItems[indexPath.item * 4]
            cell.statusLabel.text = self.dayItems[indexPath.item * 4 + 1]
            cell.maxTempLabel.text = self.dayItems[indexPath.item * 4 + 2]
            cell.minTempLabel.text = self.dayItems[indexPath.item * 4 + 3]

        return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    func setCurrentTemp(){
        weatherAPI.weather(byLatitude: Double(city.lat)!, andLongitude: Double(city.lon)!)
        weatherAPI.performWeatherRequest(completionHandler:{(data: Data?, urlResponse: URLResponse?, error: Error?) in
            NSLog("Response Current Weather Done")
            if (error != nil) {
                print(error ?? "error")
            } else {
                do {
                    self.responseWeatherApi = try CurrentResponseOpenWeatherMap(data: data!)
                    DispatchQueue.main.async { [unowned self] in
                        self.cityTempLabel.text = String(Int(self.responseWeatherApi.getTemperature())) + "°"
                        self.cityStatusLabel.text = String(self.responseWeatherApi.getDescription())
                        
                        let tempMin = String(Int(self.responseWeatherApi.getTempMin())) + "°"
                        let tempMax = String(Int(self.responseWeatherApi.getTempMax())) + "°"
                        
                        self.maxMinTempLabel.text = tempMax + "  " + tempMin
                    }
                } catch let error as Error {
                    
                }
            }
        })
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
