//
//  DetailViewController.swift
//  trial weather app
//
//  Created by Laura Zhou on 11/30/17.
//  Copyright © 2017 Ran Li. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityStatusLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!

    let hourCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layoutHourView:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    let dayCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    var items = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var dayItems = ["Mon", "Tue", "Wed", "Thur", "Fri"]
    
//    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2), collectionViewLayout: layout)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutHourView.scrollDirection = UICollectionViewScrollDirection.vertical
        
        hourCollectionView.setCollectionViewLayout(layoutHourView, animated: true)
        hourCollectionView.delegate = self
        hourCollectionView.dataSource = self
        hourCollectionView.backgroundColor = UIColor.clear
        
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.backgroundColor = UIColor.clear
        
        self.hourCollectionView.register(ForecastDataCellViewCollectionViewCell.self, forCellWithReuseIdentifier: "hourCell")
        self.dayCollectionView.register(DayForecastCollectionViewCell.self, forCellWithReuseIdentifier: "dayCell")
        self.view.addSubview(hourCollectionView)
        self.view.addSubview(dayCollectionView)
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
            print(self.dayItems[indexPath.row])
        cell.dayLabel.text = self.dayItems[indexPath.item]
        cell.statusLabel.text = self.dayItems[indexPath.item]
        cell.maxTempLabel.text = self.dayItems[indexPath.item]
        cell.minTempLabel.text = self.dayItems[indexPath.item]

        return cell
        }
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath as IndexPath) as! ForecastDataCellViewCollectionViewCell
//
//
//        // Use the outlet in our custom class to get a reference to the UILabel in the cell
//        cell.timeLabel.text = self.items[indexPath.item]
//        cell.statusLabel.text = self.items[indexPath.item]
//        cell.temperatureLabel.text = self.items[indexPath.item]
//
//        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
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
