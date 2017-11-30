//
//  DetailViewController.swift
//  trial weather app
//
//  Created by Laura Zhou on 11/30/17.
//  Copyright © 2017 Ran Li. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ForecastDataCellViewCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.timeLabel.text = self.items[indexPath.item]
        cell.statusLabel.text = self.items[indexPath.item]
        cell.temperatureLabel.text = self.items[indexPath.item]
//        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
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
