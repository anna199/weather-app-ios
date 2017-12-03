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


    var items = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var dayItems = ["Mon", "Tue", "Wed", "Thur", "Fri"]
    var curTemp = ""
    var city: City = City(name: "San Jose, CA, United States", lat: "37.3382082", lon: "-121.8863286")!

    override func viewDidLoad() {
        super.viewDidLoad()

        cityNameLabel.text = city.name
        cityTempLabel.text = curTemp
        
        let dateFormatterForDetail = DateFormatter()
        dateFormatterForDetail.timeZone = NSTimeZone(name: (city.timeZoneId)) as! TimeZone
        dateFormatterForDetail.dateFormat = "EEE, MMM d, y"
        dateLabel.text = dateFormatterForDetail.string(from : Date())
        
        
        apiKey = "b4631e5c54e1a3a9fdda89fca90d4114"
        weatherAPI = OpenWeatherMapAPI(apiKey: self.apiKey, forType: OpenWeatherMapType.Current)
        weatherAPI.setTemperatureUnit(unit: TemperatureFormat.Celsius)
        
        //assign vals to items
        setCurrentTemp()
        
        //assign vals to dayItems
     
        items = prepareItems()
        
        //assign vals to dayItems
     
        hourCollectionView.delegate = self
        hourCollectionView.dataSource = self
        hourCollectionView.backgroundColor = UIColor.clear
        
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.backgroundColor = UIColor.clear
        
    }


    func prepareItems() ->[String] {
        
        
        weatherAPI = OpenWeatherMapAPI(apiKey: "b4631e5c54e1a3a9fdda89fca90d4114", forType: OpenWeatherMapType.Forecast)
        weatherAPI.weather(byLatitude: Double(city.lat)!, andLongitude: Double(city.lon)!)
        
        var item : [String]
        weatherAPI.performWeatherRequest(completionHandler:{(data: Data?, urlResponse: URLResponse?, error: Error?) in
            if (error != nil) {
                print("laura: error1")
                //Handling error
            } else {
                do {
                    let responseWeatherApi = try CurrentResponseOpenWeatherMap(data: data!)
                    
                    print("crazy 277")
//                    print(responseWeatherApi.getCityName())
//                    print("laura: " + responseWeatherApi.getDescription())
                    
                    
                } catch let error as Error {
                    //Handling error
                    print("laura: error2")
                }
            }
        })
        
        
        
        
        
        return items
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.hourCollectionView) {
            print("aaaaaaaaaaaa")
            return self.items.count
        } else {
            print("bbbbbbbbbbbbbb")
            return self.dayItems.count
        }
//        return self.items.count
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        
        if (collectionView == self.hourCollectionView) {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath as IndexPath) as! ForecastDataCellViewCollectionViewCell


            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.timeLabel.text = self.items[indexPath.item]
            cell.statusLabel.text = self.items[indexPath.item]
            cell.temperatureLabel.text = self.items[indexPath.item]

            return cell
        } else{

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath as IndexPath) as! DayForecastCollectionViewCell

            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.dayLabel.text = self.dayItems[indexPath.item]
            cell.statusLabel.text = self.dayItems[indexPath.item]
            cell.maxTempLabel.text = self.dayItems[indexPath.item]
            cell.minTempLabel.text = self.dayItems[indexPath.item]

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
                        self.cityTempLabel.text = String(Int(self.responseWeatherApi.getTemperature()))
                        self.cityStatusLabel.text = String(self.responseWeatherApi.getDescription())
                        var tempMin = String(Int(self.responseWeatherApi.getTempMin()))
                      
                       
                        var tempMax = String(Int(self.responseWeatherApi.getTempMax()))
                        //let indexMax = tempMin.index(tempMax.endIndex, offsetBy: -2)
                        //tempMax = tempMax.substring(to: indexMax)
                        
                        self.maxMinTempLabel.text = tempMax + " " + tempMin
                    }
                }catch let error as Error {
                    
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
