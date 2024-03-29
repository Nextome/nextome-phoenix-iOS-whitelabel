//
//  MapViewController.swift
//  nextome-phoenix-iOS-whitelabel
//
//  Created by Anna Labellarte on 28/03/23.
//

import UIKit
import MapKit
import CoreLocation
import BLTNBoard

class OutdoorMapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    //UIView Components
    @IBOutlet weak var mapView: MKMapView!
    
    //Controllers Components
    let locationManager = CLLocationManager()
    lazy var bulletinManager: BLTNItemManager = {
        let page = BLTNPageItem(title: "Search nearby venues")
        page.descriptionText = "Get current location data..."
        
        return BLTNItemManager(rootItem: page)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()

    }
    
    private func commonInit(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        
       
    }
    
    //MARK: MAP Position observer
    @objc func onDidReceivePosition(_ notification: Notification){
        //self.bulletinManager.dismissBulletin(animated: true)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    //MARK: Outdoor stream
    @objc func onDidReceiveOutdoor(_ notification: Notification){
        
        //receive position
        let positionData = notification.userInfo as? [String : Double]
        
        let lat = positionData!["lat"]!
        let lng = positionData!["lng"]!
        
        //LOG WRITER
        print("SDK Outdoor -> lat: \(lat) \n lng: \(lng)")
        //MARK: LOG STREAM
        NotificationCenter.default.post(name: Notification.Name("LOG_WRITER"), object: nil, userInfo: ["log": "Outdoor -> lat: \(lat) \n lng: \(lng)"])
        

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        mapView.mapType = MKMapType.standard

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Current Location"
        mapView.addAnnotation(annotation)

        //centerMap(locValue)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus: CLAuthorizationStatus

        if #available(iOS 14, *) {
            authorizationStatus = manager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        switch (authorizationStatus){
        case .authorizedAlways, .authorizedWhenInUse:
            startMap()
        case .restricted, .denied:
            showMissingPermissionAlert()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            showMissingPermissionAlert()
        }
    }

    func showMissingPermissionAlert(){
        print("Missing permissions")
    }
    
    func startMap(){
        locationManager.startUpdatingLocation()
    }
}



