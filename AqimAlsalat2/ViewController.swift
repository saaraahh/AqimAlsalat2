//
//  ViewController.swift
//  First
//
//  Created by Dalal Mansour on 2/9/18.
//  Copyright © 2018 Dalal Mansour. All rights reserved.
//
//hhh222
//jj
//jj
import UIKit
import GoogleMaps
import MapKit
class ViewController:UIViewController,GMSMapViewDelegate {
    
    //constants and variables
    lazy var mapView = GMSMapView()
    var locationManager = CLLocationManager()
    var  userLocation = CLLocation()
    let txt =  "we need your location please open the setting and enaible your location"
    //markers locations
    var userLocation1 =  CLLocation(latitude: 24.723561, longitude: 46.622433)
    var userLocation2 =  CLLocation(latitude: 24.713739, longitude: 46.613850)
    var userLocation3 =  CLLocation(latitude: 24.715295, longitude: 46.620974)
    //distance
    var distanceInMeters, distanceInMeters1, distanceInMeters2 :Double?
    var d1,d2 :Double?
    var userLoc =  CLLocation(latitude: 0, longitude: 0)
    var nodes = PriorityQueue<Mosque>(sort: { $0.priority < $1.priority })
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 24.725239,longitude: 46.637492, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
        
        let button = UIButton(frame: CGRect(x: 300, y: 50, width: 100, height: 100))
        button.setTitle("Dalal", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action:#selector(handleRegister(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.position)
        return true
    }
    
    
    func selectAutmatically(latitude: Double, longitude: Double)
    {
        var userLocation0 =  CLLocation(latitude: latitude, longitude: longitude)
        let distanceInMeters = userLocation0.distance(from: userLocation1)
        let distanceInMeters2 = userLocation0.distance(from: userLocation2)
        let distanceInMeters3 = userLocation0.distance(from: userLocation3)
        
        //nodes
        let m =  Mosque(priority: distanceInMeters, name: "a",location:(userLocation2), status:"grey")
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
    
    @IBAction func handleRegister(sender: UIButton)
    {
        print("hellllllooooo")
        selectAutmatically(latitude: d1!, longitude: d2!)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if( status == CLAuthorizationStatus.denied){
            showLocationDisable()
        }
    }
    
    func showLocationDisable(){  //call this method if the user diable his location
        let alert = UIAlertController(title: "you disable the app", message:txt, preferredStyle: .alert)//preferredStyle can be alert or action sheet *Dalal*
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let open = UIAlertAction(title: "open setting", style: .default) {(action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }// end if condition
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
    
    func addMarkers(lat: Double,long: Double){
        
        let muser = GMSMarker()
        muser.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        muser.title = "useer location"
        muser.snippet = "Australia"
        muser.icon = UIImage(named: "user")
        muser.map = mapView
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 24.723561, longitude: 46.622433)
        marker.title = "mosque1"
        marker.snippet = "Australia"
        marker.icon = UIImage(named: "green")
        marker.map = mapView
        
        
        let markerSquirt = GMSMarker()
        markerSquirt.position = CLLocationCoordinate2D(latitude: 24.713739, longitude: 46.613850)
        markerSquirt.title = "mosque2"
        markerSquirt.snippet = "Squirtle lives here"
        markerSquirt.icon = UIImage(named: "grey")
        markerSquirt.map = mapView
        
        let markerSquirt2 = GMSMarker()
        markerSquirt2.position = CLLocationCoordinate2D(latitude: 24.715295, longitude: 46.620974)
        markerSquirt2.title = "mosque3"
        markerSquirt2.snippet = "Squirtle lives here"
        markerSquirt2.isTappable = true
        markerSquirt2.icon = UIImage(named: "orange")
        markerSquirt2.map = mapView
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}//end class
extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first!
        _ = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude,
                                              longitude: userLocation.coordinate.longitude, zoom: 13.0)
        
        userLoc = userLocation
        d1 = userLocation.coordinate.latitude
        d2 = userLocation.coordinate.longitude
        
        
        locationManager.stopUpdatingLocation()
        addMarkers(lat: d1!,long: d2!)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
