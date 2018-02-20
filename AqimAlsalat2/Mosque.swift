//
//  Mosque.swift
//  First
//
//  Created by Dalal Mansour on 2/9/18.
//  Copyright © 2018 Dalal Mansour. All rights reserved.
//
//dalal
//dala2
//dalal3
//dalal4
//d555
//d6hh
import UIKit
import CoreLocation

struct Mosque {
    var priority:Double //based on distance(nearst one)
    var name:String?
    var location = CLLocation(latitude: 0.0, longitude: 0.0)
    var status:String?
    var id:Int?
    var latitude:Double?
    var longitude:Double?
    var nameE:String?
    
    
    //var des:String?

   
    init(priority:Double,name:String,location:CLLocation,status:String) {
 
        self.priority=priority
        self.name=name
        self.location = location
        self.status=status
    }
    
  
     init(id:Int,name:String,nameE:String,lat:Double,long:Double,status:String ) {
        let c = CLLocation(latitude:lat, longitude: long)
    self.init(priority: 1, name: name, location: c, status: status)
    self.id=id
    self.name=name
    self.nameE=nameE
    self.latitude=lat
    self.longitude=long
    self.status=status
    }
    
    
}
                        
    
        

    
    


