//
//  City.swift
//  trial weather app
//
//  Created by Ran Li on 11/28/17.
//  Copyright © 2017 Ran Li. All rights reserved.
//

//
//  Meal.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log


class City: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var lat: String
    var lon: String
    var timeZoneId: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cities")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let lat = "lat"
        static let lon = "lon"
        
    }
    
    //MARK: Initialization
    
    init?(name: String, lat: String, lon: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.lat = lat
        self.lon = lon
        self.timeZoneId = ""
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(lat, forKey: PropertyKey.lat)
        aCoder.encode(lon, forKey: PropertyKey.lon)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let lat = aDecoder.decodeObject(forKey: PropertyKey.lat)
        
        let lon = aDecoder.decodeObject(forKey: PropertyKey.lon)
        
        // Must call designated initializer.
        self.init(name: name, lat: lat as! String, lon: lon as! String)
        
    }
    
}

