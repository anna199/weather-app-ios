//
//  ViewController.swift
//  trial weather app
//
//  Created by Ran Li on 11/28/17.
//  Copyright © 2017 Ran Li. All rights reserved.
//
import UIKit
import GooglePlaces



class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate , LocateOnTheMap,GMSAutocompleteFetcherDelegate {
    
    var valueToPass:String!
    var cities = [City]()
    
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
        
        cell.nameLabel.text = city.name
       // cell.photoImageView.image = meal.photo
       // cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = cities[indexPath.row].name
       // DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "mySegue", sender: self)
        //}
        print(indexPath.row)
    }
    func prepare(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "mySegue") {
            // initialize new view controller and cast it as your view controller
            var viewController = segue.destination as! DetailViewController
            // your new view controller should have property that will store passed value
           // viewController.passedValue = valueToPass
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
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
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }
    
    
    
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //loadData()
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
            //loadSampleMeals()
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
            
            self.cities.removeAll()
            self.loadData()
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
