//
//  ViewController.swift
//  trial weather app
//
//  Created by Ran Li on 11/28/17.
//  Copyright © 2017 Ran Li. All rights reserved.
//
import UIKit
import GooglePlaces
import OpenWeatherMapAPIConsumer
import Toast_Swift


class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate , LocateOnTheMap,GMSAutocompleteFetcherDelegate, CLLocationManagerDelegate {
    
    var cities = [City]()
    var weatherAPI : OpenWeatherMapAPI!
    var apiKey : String!
    var responseWeatherApi : ResponseOpenWeatherMapProtocol!
    var temp: [String] = []
    let locationManager = CLLocationManager()
    var cityCurrent: City!
    var currentlong: Double!
    var currentlat: Double!
    
    let defaults = UserDefaults.standard
  
    @IBAction func CFCoverter(_ sender: Any) {
        if (defaults.string(forKey:"metric") == "F"){
            print("C")
            defaults.set("C", forKey: "metric")
            
        } else {
             print("F")
            defaults.set("F", forKey: "metric")
        }
        cities.removeAll()
        loadData()
        self.tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CityTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let city = cities[indexPath.row]
        var fullNameArr = city.name.components(separatedBy: ",")
        var firstName: String = fullNameArr[0]
        cell.nameLabel.text = firstName
        print("&&&&&city.name: " + city.name)


        self.getLocaltime(city: city, cell:cell)
    
        if (defaults.string(forKey:"metric") == "F") {
            weatherAPI.setTemperatureUnit(unit: TemperatureFormat.Fahrenheit)
        } else {
            weatherAPI.setTemperatureUnit(unit: TemperatureFormat.Celsius)
        }
        weatherAPI.weather(byLatitude: Double(city.lat)!, andLongitude: Double(city.lon)!)
        weatherAPI.performWeatherRequest(completionHandler:{(data: Data?, urlResponse: URLResponse?, error: Error?) in
            NSLog("Response Current Weather Done")
            if (error != nil) {
//                self.showAddOutfitAlert(message: "Error fetching the current weather", error: error)
            } else {
                do {
                    self.responseWeatherApi = try CurrentResponseOpenWeatherMap(data: data!)
                    DispatchQueue.main.async { [unowned self] in
                        cell.temp.text = String(Int(self.responseWeatherApi.getTemperature())) + "°"
                    }
               }catch let error as Error {
                    self.showAddOutfitAlert(message: "Error fetching the forecast weather", error: error)
                }
                }
            } as! (Data?, URLResponse?, Error?) -> Void)
        
        
        return cell
    }
    private func getLocaltime(city: City, cell:CityTableViewCell) {
        //self.dismiss(animated: true, completion: nil)
        let timeInterval = NSDate().timeIntervalSince1970
        // 2
        let urlpath = "https://maps.googleapis.com/maps/api/timezone/json?location=\(city.lat),\(city.lon)&&timestamp=\(timeInterval)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlpath!)
        print(url!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

       // dateFormatter.timeZone = NSTimeZone(name: timeZoneId) as! TimeZone
        let date : Date = Date()
        var todaysDate = dateFormatter.string(from: date)

        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
        
            // 3
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary

                let dstOffset =   dic.value(forKey: "dstOffset") as! Double
                print(dstOffset)
                let timeZoneId =   dic.value(forKey: "timeZoneId") as! String
                print(timeZoneId)
            
                dateFormatter.timeZone = NSTimeZone(name: timeZoneId) as! TimeZone
                todaysDate = dateFormatter.string(from: date)
                    
                DispatchQueue.main.async { [unowned self] in
                    cell.time.text = todaysDate
                    city.timeZoneId = timeZoneId
                }
                    
                }
            }  catch {
                    print("Error")
            }
        }
        task.resume()
    }
    private func showAddOutfitAlert(message: String, error: Error?) {
        let alert = UIAlertController(title: "Oups!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            print(error ?? "No error object")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        currentlat = locValue.latitude
        currentlong = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as? CityTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "detailViewIdentifier") as! DetailViewController
        myVC.city = cities[indexPath.row]
        myVC.currentCity = cityCurrent
        myVC.cursor = indexPath.row
        myVC.cities = self.cities
        navigationController?.pushViewController(myVC, animated: true)
        
        print(indexPath.row)
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cities.removeAll()
            loadData()
            self.tableView.reloadData()
            cities.remove(at: indexPath.row)
            saveCities()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }
    
    
    
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //loadData()
        apiKey = "b4631e5c54e1a3a9fdda89fca90d4114"
        weatherAPI = OpenWeatherMapAPI(apiKey: self.apiKey, forType: OpenWeatherMapType.Current)
        if (defaults.string(forKey:"metric") == "F") {
            weatherAPI.setTemperatureUnit(unit: TemperatureFormat.Fahrenheit)
        } else {
            weatherAPI.setTemperatureUnit(unit: TemperatureFormat.Celsius)
        }
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self as? CLLocationManagerDelegate
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
        
//        }
         var currentLocation: CLLocation!
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locationManager.location
          currentlat = currentLocation.coordinate.latitude
            currentlong = currentLocation.coordinate.longitude
            
               var location = CLLocation(latitude: currentlat, longitude: currentlong)
            fetchCountryAndCity(location: location) { country, city in
                print("country:", country)
                print("city:", city)
                self.cityCurrent = City(name: city + ", " + country, lat: String(self.currentlat), lon: String(self.currentlong))
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        //self.tableView.reloadData()
        
    }
    func loadData(){
        if let savedCities = loadCities() {
            cities += savedCities
        }
        else {
            // Load the sample data.
        }
    }
    func loadData2(citiesCount: Int){
        var temp: Bool = true
        if let savedCities = loadCities() {
            temp = false
            cities += savedCities
        }
        else {
            // Load the sample data.
        }
        if (temp) {
            //print("this is a error " + String(citiesCount) + " " + cities.count)
            var style = ToastStyle()
            self.view.makeToast("City already been added", duration: 3.0, position: .bottom, style: style)
            // self.showAddOutfitAlert(message: "Error fetching the forecast weather", error: nil)
        }
    }
    private func loadCities() -> [City]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: City.ArchiveURL.path) as? [City]
    }
    private func saveCities() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(cities, toFile: City.ArchiveURL.path)
        if isSuccessfulSave {
            print("Save successfully")
        } else {
            print("Not Save Successfully!!!")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        gmsFetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
        gmsFetcher.delegate = self
        
    }
    
    /**
     action for search location by address
     
     - parameter sender: button search location
     */
    @IBAction func searchWithAddress(_ sender: AnyObject) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated:true, completion: nil)
        cities.removeAll()
        loadData()
        self.tableView.reloadData()
    }
    
    @IBAction func AddCurrentCity(_ sender: Any) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        cities.removeAll()
       loadData()
        self.tableView.reloadData()
        var isExist = false
        if (cityCurrent == nil) {
            var style = ToastStyle()
            self.view.makeToast("City already been added", duration: 1.0, position: .bottom, style: style)
        } else {
            for city in self.cities{
                if (city.name == cityCurrent.name) {
                    isExist = true
                    break
                }
            }
        }
        if ((cities != nil && isExist) || cityCurrent == nil) {
            var style = ToastStyle()
            self.view.makeToast("City already been added", duration: 1.0, position: .bottom, style: style)
        } else {
            cities.append(cityCurrent)
            self.saveCities()
            self.cities.removeAll()
            loadData()
            self.tableView.reloadData()
        }
        
    }
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
   
    /**
     Locate map with longitude and longitude after search location on UISearchBar
     
     - parameter lon:   longitude location
     - parameter lat:   latitude location
     - parameter title: title of address location
     */
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        /*cities.removeAll()
        loadData()
        self.tableView.reloadData()*/
        DispatchQueue.main.async { () -> Void in
            // var temp = self.cities.count;
            self.cities.removeAll()
            self.loadData2(citiesCount: 0)
            self.tableView.reloadData()
        }
    }
    
    
    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
