//
//  ViewController.swift
//  First
//
//  Created by Dalal Mansour on 2/9/18.
//  Copyright © 2018 Dalal Mansour. All rights reserved.
//
//daaa
import UIKit
import GoogleMaps
import MapKit
import Firebase
import GeoFire

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    // database
    var ref: DatabaseReference!
   
    
    //constants and variables
    lazy var mapView = GMSMapView()
    var locationManager = CLLocationManager()
    var camera = GMSCameraPosition.camera(withLatitude: 24.725239, longitude: 46.637492, zoom: 13.0)
    var  userLocation = CLLocation()
    let txt =  "we need your location please open the setting and enaible your location"
    
    //markers locations
    var userLocation1 =  CLLocation(latitude: 24.723561, longitude: 46.622433)
    var userLocation2 =  CLLocation(latitude: 24.713739, longitude: 46.613850)
    var userLocation3 =  CLLocation(latitude: 24.715295, longitude: 46.620974)
    
    //distance
    var distanceInMeters, distanceInMeters1, distanceInMeters2 :Double?
    var d1,d2 :Double?
    
    
    
    func autmatically(d1:Double,d2:Double)
    {
        
        var nodes = PriorityQueue<Mosque>(sort: { $0.priority < $1.priority })
        var userLocation0 =  CLLocation(latitude: d1, longitude: d2)
        let distanceInMeters = userLocation0.distance(from: userLocation1)
        let distanceInMeters2 = userLocation0.distance(from: userLocation2)
        let distanceInMeters3 = userLocation0.distance(from: userLocation3)
        
        
        
        
        //nodes
        let m =  Mosque(priority: distanceInMeters, name: "a",location:(userLocation2), status:"green")
        let  m1 = Mosque(priority: distanceInMeters2, name: "b",location:(userLocation3), status:"orange")
        let m2 = Mosque(priority: distanceInMeters3, name: "c",location:(userLocation1), status:"green")
        
        
        print("11111a:\(distanceInMeters)")
        print("22222b:\(distanceInMeters2)")
        print("333333c:\(distanceInMeters3)")
        
        //peek Node
        var peekNode = Mosque(priority: 1, name: "dalal", location: (userLocation1), status:"grey")
        
        if(m.status != "red")
        {
            nodes.enqueue(element: m)
            nodes.enqueue(element: m1)
            nodes.enqueue(element: m2)
            
            peekNode = nodes.peek()!
            print(" * Node(priority: \(peekNode.priority))"+" * Node(names: \(peekNode.location.coordinate.latitude))"+" * Node(names: \(peekNode.name))")
            
            //callGoogleMaps(latitude: peekNode.location.coordinate.latitude,longitude: peekNode.location.coordinate.longitude)
            
        }
        else{
            let alert = UIAlertController(title: "no available mosque", message: "There is no available mosque for congregation prayer//spilling", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //database
        var keys = [String:CLLocation]()
        
        let ref = Database.database().reference()
     //   ref.child("mosque").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let geofireRef = ref.child("locations")
            let geoFire = GeoFire(firebaseRef: geofireRef)
           
            let center = CLLocation(latitude:24.723561 , longitude: 46.637492)
            var circleQuery = geoFire.query(at: center, withRadius: 5)
            var queryHandle = circleQuery.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
                keys[key] = location
                print(keys.count)
                print("Key '\(key)' entered the search area and is at location '\(location.coordinate.latitude)' '\(location.coordinate.longitude)'")
            })
        
          /*  if let cakeSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
               for cakes in cakeSnapshot {
                
                     if let cake = cakes.value as? Dictionary <String, Any>  {
                        let key = cakes.key as String
                        if let lat = cake["Latitude"] as? String{
                            if let lon = cake["Longitude"] as? String{
                        let latitude = Double(lat) ?? 0.0
                        let longitude = Double(lon) ?? 0.0
                        
                                geoFire.setLocation(CLLocation(latitude:latitude as! CLLocationDegrees , longitude: longitude as! CLLocationDegrees), forKey:key)
                                
                            }}
                        
                        }
                    
                  }
               
            }
                
            })*/
        
      
       // let rootRef = Database.database().reference()
       // let geoRef = GeoFire(firebaseRef: rootRef.child("locations"))
      /* let geofireRef = Database.database().reference().child("locations")
        let geoFire = GeoFire(firebaseRef: geofireRef)
       // geoFire.setLocation(CLLocation(latitude: 24.723561, longitude: 46.637492), forKey:"0")
        let center = CLLocation(latitude:24.723561 , longitude: 46.637492)
        var circleQuery = geoFire.query(at: center, withRadius: 5)
        
        var queryHandle = circleQuery.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            print("Key '\(key)' entered the search area and is at location '\(location)'")
        })
        */
       /* ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value
                
                print("key = \(key)  value = \(value!)")
            }
        })
        */
        
        // ref = Database.database().reference()
        //let geofireRef = ref.child("users_locations")
        //let geoFire = GeoFire(firebaseRef: geofireRef)
        
       // var lat = Array<Double>()
       /* for i in 0...1500 {
            let j = String(i)
        ref.child("mosque").child(j).child("Latitude").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            var lat = value?["Latitude"]? ["Longitude"] as? String ?? ""
         
            })
        }*/
        
        
        //lat.sort(by: {($0 as AnyObject).key > ($1 as AnyObject).key})
        
        //user location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        //create priority queue
        
        
        //  var nodes = PriorityQueue<Mosque>(sort: { $0.priority < $1.priority })
        
        // create distance and nodes
        
        //distance
        /*  var userLocation0 =  CLLocation(latitude: d1!, longitude: d2!)
         let distanceInMeters = userLocation0.distance(from: userLocation1)
         let distanceInMeters2 = userLocation0.distance(from: userLocation2)
         let distanceInMeters3 = userLocation0.distance(from: userLocation3)
         
         
         
         
         //nodes
         let m =  Mosque(priority: distanceInMeters, name: "a",location:(userLocation2), status:"green")
         let  m1 = Mosque(priority: distanceInMeters2, name: "b",location:(userLocation3), status:"orange")
         let m2 = Mosque(priority: distanceInMeters3, name: "c",location:(userLocation1), status:"green")
         
         
         print("11111a:\(distanceInMeters)")
         print("22222b:\(distanceInMeters2)")
         print("333333c:\(distanceInMeters3)")
         
         //peek Node
         var peekNode = Mosque(priority: 1, name: "dalal", location: (userLocation1), status:"grey")
         
         if(m.status != "red")
         {
         nodes.enqueue(element: m)
         nodes.enqueue(element: m1)
         nodes.enqueue(element: m2)
         
         peekNode = nodes.peek()!
         print(" * Node(priority: \(peekNode.priority))"+" * Node(names: \(peekNode.location.coordinate.latitude))"+" * Node(names: \(peekNode.name))")
         
         //callGoogleMaps(latitude: peekNode.location.coordinate.latitude,longitude: peekNode.location.coordinate.longitude)
         
         }
         else{
         print("reeed")
         }*/
        
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last!
        _ = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude,
                                          longitude: userLocation.coordinate.longitude, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        d1 = userLocation.coordinate.latitude
        d2 = userLocation.coordinate.longitude
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 24.723561, longitude: 46.622433)
        marker.title = "mosque1"
        marker.snippet = "Australia"
        marker.map = mapView
        
        
        let markerSquirt = GMSMarker()
        markerSquirt.position = CLLocationCoordinate2D(latitude: 24.713739, longitude: 46.613850)
        markerSquirt.title = "mosque2"
        markerSquirt.snippet = "Squirtle lives here"
        markerSquirt.map = mapView
        
        let markerSquirt2 = GMSMarker()
        markerSquirt2.position = CLLocationCoordinate2D(latitude: 24.715295, longitude: 46.620974)
        markerSquirt2.title = "mosque3"
        markerSquirt2.snippet = "Squirtle lives here"
        markerSquirt2.map = mapView
        
        
        autmatically(d1: d1!, d2: d2!)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if( status == CLAuthorizationStatus.denied){
            showLocationDisable()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    func showLocationDisable(){
        let alert = UIAlertController(title: "you disable the app", message:txt, preferredStyle: .alert)//preferredStyle can be alert or action sheet *Dalal*
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let open = UIAlertAction(title: "open setting", style: .default) {(action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }// end of if condition
        }
        alert.addAction(cancel)
        alert.addAction(open)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func callGoogleMaps(latitude: Double,longitude: Double)//check spelling
    {
        
        let strLat = String (latitude)
        let strLong = String (longitude)
        //Use this code for opening in google map if it's installed else open in default apple map.
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?center=\(strLat),\(strLong )")!, options: [:], completionHandler: nil)
            
        } else if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com")! as URL))
        {
            showLocationDisable()
            UIApplication.shared.open(URL(string: "https://maps.google.com/?q=@\(strLat),\(strLong )")!, options: [:], completionHandler: nil)
        }
            
        else {
            print("Opening in Apple Map")
            
            let coordinate = CLLocationCoordinate2DMake(23.035007, 72.529324)
            let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.02))
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
            mapItem.name = "Dalal"
            mapItem.openInMaps(launchOptions: options)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension ViewController: GMSMapViewDelegate{
    
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
}
}
