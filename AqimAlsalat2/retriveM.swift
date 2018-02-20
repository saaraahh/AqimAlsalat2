//
//  retriveM.swift
//  AqimAlsalat2
//
//  Created by sara on 13/02/2018.
//  Copyright © 2018 ساره عبدالله. All rights reserved.
//
/*
import UIKit
import Alamofire

class retriveM: NSObject,URLSessionDataDelegate {

     var data : NSMutableData = NSMutableData()
    
    func retrieveNearest(lat:Double,long:Double){
        
        let url = NSMutableURLRequest(url: NSURL(string: "http://mosqueksu.com/mosqueksu/retrieveNearest.php")! as URL )
        url.httpMethod = "POST"
        //url.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postString = "latitude=\(lat),longitude=\(long)"
       // Alamofire.request(.GET,url).responseJSON { response in
        url.httpBody = postString.data(using: String.Encoding.utf8)
        var session: URLSession!
        
      let configuration = URLSessionConfiguration.default
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: url as URLRequest)
        
        task.resume()
        
                    
   }
    
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        self.data.append(data as Data);
    }
    
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        if error != nil
        {
            print("Not Found", error as Any )
            
        }
        else
        {
            print("Ok")
            self.parseJSON()
        }
        
    }
    
    
    func parseJSON()
    {
        
       var jsonResult: NSArray = NSArray()
        
        do
        {
           //  jsonResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! NSArray
            jsonResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! NSArray
            
            print("jsonResult.count",jsonResult.count)
        }
        catch let error as NSError
        {
            print("jsonResult: ", error)
        }
        
        
        var jsonElement: NSDictionary = NSDictionary()
        var contador = 0
        for i in (0..<jsonResult.count)
        {
            jsonElement = jsonResult[i] as! NSDictionary
            
            if let id = jsonElement["OBJECTID"] as? Int,
                let name = jsonElement["ArabicName"] as? String,
                let nameE = jsonElement["EnglishNam"] as? String,
                let lat = jsonElement["Latitude"] as? Double,
                let long = jsonElement["Longitude"] as? Double,
                let status = jsonElement["status"] as? String,
                let distance = jsonElement["distance"] as? Double
            {
                print("id: ", id)
                print("name: ", name)
                print("nameE: ", nameE)
                print("latitude",lat)
                print("longitude",long)
                print ("status",status)
                print ("distance",distance)
            }
            
        }
    }
}
*/
