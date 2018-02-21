//
//  ViewController.swift
//  First
//
//  Created by Dalal Mansour on 2/9/18.
//  Copyright © 2018 Dalal Mansour. All rights reserved.
//dd
import UIKit
import GoogleMaps
import MapKit
import Firebase
import GeoFire
import Alamofire
import SwiftyJSON

class ViewController:UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    // database
    var ref: DatabaseReference!
    
    //constants and variables
    lazy var mapView = GMSMapView()
    var locationManager = CLLocationManager()
    var  userLocation = CLLocation()
    let txt =  "we need your location please open the setting and enaible your location"
    
    //temprarly
    var userLocation1 =  CLLocation(latitude: 24.723561, longitude: 46.622433)
    var userLocation2 =  CLLocation(latitude: 24.713739, longitude: 46.613850)
    var userLocation3 =  CLLocation(latitude: 24.715295, longitude: 46.620974)
    
    //distance
    var distanceInMeters=0.0
    var distanceInMeters1=0.0
    var distanceInMeters2=0.0
    
    var userLoc =  CLLocation(latitude: 0, longitude: 0)
    var nodes = PriorityQueue<Mosque>(sort: { $0.priority < $1.priority })
    var  mosques=[Mosque]()
    
    
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.position)
        print("majd")
        let text = "Do you want to use google maps application?"
        
        let alert = UIAlertController(title: "Google Maps", message:text, preferredStyle: .alert)
        
        let No = UIAlertAction(title: "No", style: .cancel)
        { (action) in
            print("jjjjjjjj")
            let origin = "\(self.userLoc.coordinate.latitude),\(self.userLoc.coordinate.longitude)"
            let destination = "\(marker.position.latitude),\(marker.position.longitude)"
            
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
            
            Alamofire.request(url).responseJSON { response in
                
                print(response.request as Any)
                print(response.response as Any)
                print(response.data as Any)
                print(response.result as Any)
                do{
                    let json = try JSON(data: response.data!)
                    let routes = json["routes"].arrayValue
                    for route in routes
                    {
                        let routeOverviewPolyline = route["overview_polyline"].dictionary
                        let points = routeOverviewPolyline?["points"]?.stringValue
                        let path = GMSPath.init(fromEncodedPath: points!)
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeWidth = 8
                        polyline.strokeColor = UIColor.blue
                        polyline.map = self.mapView
                    }
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        }
        
        let yes = UIAlertAction(title: "Yes", style: .default)
        {  (action) in
            self.callGoogleMaps(latitude: marker.position.latitude, longitude: marker.position.longitude)
        }
        alert.addAction(No)
        alert.addAction(yes)
        self.present(alert, animated: true, completion: nil)
        return true
    }
    
    func selectAutmatically(userLoc:CLLocation)
    {
        
        let userLocation0 =  CLLocation(latitude: userLoc.coordinate.latitude, longitude: userLoc.coordinate.longitude)
        let distanceInMeters = userLocation0.distance(from: userLocation1)
        let distanceInMeters2 = userLocation0.distance(from: userLocation2)
        let distanceInMeters3 = userLocation0.distance(from: userLocation3)
        
        
        //nodes
        let m =  Mosque(priority: distanceInMeters, name: "a",location:(userLocation2), status:"grey")
        let  m1 = Mosque(priority: distanceInMeters2, name: "b",location:(userLocation3), status:"orange")
        let m2 = Mosque(priority: distanceInMeters3, name: "c",location:(userLocation1), status:"green")
        
        mosques.append(m)
        mosques.append(m1)
        mosques.append(m2)
        
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
            print(" * Node(priority: \(peekNode.priority))"+" * Node(names: \(peekNode.location.coordinate.latitude))"+" * Node(names: \(String(describing: peekNode.name)))")
            
            //callGoogleMaps(latitude: peekNode.location.coordinate.latitude,longitude: peekNode.location.coordinate.longitude)
        }
        else{
            let alert = UIAlertController(title: "no available mosque", message: "There is no available mosque for congregation prayer//spilling", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }// end selectAutmatically
    
    
    
    
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
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let m =  Mosque(priority: distanceInMeters, name: "a",location:(userLocation2), status:"grey")
        let m1 = Mosque(priority: distanceInMeters2, name: "b",location:(userLocation3), status:"orange")
        let m2 = Mosque(priority: distanceInMeters1, name: "c",location:(userLocation1), status:"green")
        
        mosques.append(m)
        mosques.append(m1)
        mosques.append(m2)
        
        let camera = GMSCameraPosition.camera(withLatitude: 24.725239,longitude: 46.637492, zoom: 13.0)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
        
        let button = UIButton(frame: CGRect(x: 300, y: 50, width: 100, height: 100))
        button.setTitle("Dalal", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        //button.setImage(image, for: .normal)
        self.view.addSubview(button)
        
        
    }//end view did load
    
    
    
    @IBAction func buttonClicked(sender: UIButton)
    {
        print("hellllllooooo")
        selectAutmatically(userLoc: userLoc)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if( status == CLAuthorizationStatus.denied){
            showLocationDisable()
        }
        
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
    }//end showLocationDisable method
    
    
    func callGoogleMaps(latitude: Double,longitude: Double)
    {
        
        let strLat = String (latitude)
        let strLong = String (longitude)
        //Use this code for opening in google map if it's installed else  website or open in default apple map.
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first!
        _ = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        _ = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude,
                                     longitude: userLocation.coordinate.longitude, zoom: 13.0)
        
        userLoc = userLocation
        locationManager.stopUpdatingLocation()
        addMarkers(userLoc:CLLocation(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude))
    }//end didUpdateLocations method
    
    func addMarkers(userLoc:CLLocation){
        
        let muser = GMSMarker()
        muser.position = CLLocationCoordinate2D(latitude: userLoc.coordinate.latitude, longitude: userLoc.coordinate.longitude)
        muser.title = "useer location"
        muser.snippet = "Australia"
        muser.icon = UIImage(named: "user")
        muser.map = mapView
        print("fff (\(mosques.count)")
        for ms in mosques {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: ms.location.coordinate.latitude, longitude: ms.location.coordinate.longitude)
            marker.title = ms.name
            marker.snippet = "Australia"
            
            if(ms.status=="red"){
                marker.icon = UIImage(named: "grey")
            }
            if(ms.status=="green"){
                marker.icon = UIImage(named: "green")
            }
            if(ms.status=="orange"){
                marker.icon = UIImage(named: "orange")
            }
            marker.map = mapView
        }//end for
    }//end addMarker method
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}//end class

