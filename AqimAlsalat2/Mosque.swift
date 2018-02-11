//
//  Mosque.swift
//  First
//
//  Created by Dalal Mansour on 2/9/18.
//  Copyright © 2018 Dalal Mansour. All rights reserved.
//

import UIKit
import CoreLocation

class Mosque {
    var priority:Double //based on distance(nearst one)
    var name:String?
    var location = CLLocation(latitude: 0.0, longitude: 0.0)
    var status:String?
    
    //var latitude:Double?
    // var longitude:Double?
    //var des:String?
    
    init(priority:Double,name:String,location:CLLocation,status:String) {
        self.priority=priority
        self.name=name
        self.location = location
        self.status=status
    }
    
}

