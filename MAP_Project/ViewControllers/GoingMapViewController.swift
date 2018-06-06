//
//  GoingMapViewController.swift
//  MAP_Project
//
//  Created by Sumanth Sai on 5/9/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GoingMapViewController: UIViewController,MKMapViewDelegate {
    
    var selectedEvent: GoingModel? {
        didSet{
            _ = selectedEvent?.eventId
           
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let mapView = MKMapView()
        
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 10
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
        
        view.addSubview(mapView)
        let locationString = selectedEvent?.eventLocation
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locationString!){ (placemarks, error) in
            guard
                let placemarks = placemarks,
                let locationMapCoord = placemarks.first?.location?.coordinate
                else{
                    print("Not found")
                    return
            }
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05,longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: locationMapCoord, span:span)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationMapCoord
            let string = self.selectedEvent?.eventLocation
            let eventName = self.selectedEvent?.eventName
            annotation.title = string
            annotation.subtitle = eventName
            mapView.addAnnotation(annotation)
            
            
        }
        
    }
    
}

