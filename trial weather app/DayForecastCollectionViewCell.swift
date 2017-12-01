//
//  DayForecastCollectionViewCell.swift
//  trial weather app
//
//  Created by Laura Zhou on 11/30/17.
//  Copyright © 2017 Ran Li. All rights reserved.
//

import UIKit

class DayForecastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dayLabel.text = "day"
        statusLabel.text = "status"
        maxTempLabel.text = "max"
        minTempLabel.text = "min"
    }

}
