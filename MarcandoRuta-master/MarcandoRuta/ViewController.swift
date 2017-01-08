//
//  ViewController.swift
//  MarcandoRuta
//
//  Created by Walter Llano on 08/1/17.
//  Copyright © 2017 Walter Llano. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    

    @IBOutlet weak var mapa: MKMapView!
    private let manejador = CLLocationManager()
    
    @IBAction func btnNormal(_ sender: AnyObject) {
        mapa.mapType = MKMapType.standard
    }
    
    @IBAction func btnSatelite(_ sender: AnyObject) {
        mapa.mapType = MKMapType.satellite
    }
    
    @IBAction func btnHibrido(_ sender: AnyObject) {
        mapa.mapType = MKMapType.hybrid
    }
    
    private var total: CLLocationDistance = 0.0
    private var puntoA: CLLocation!
    private var puntoB: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        manejador.distanceFilter = 50
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedWhenInUse){
            //iniciamos lecturas
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            puntoA = manager.location
            
            //ajustamos zoom al punto del usuario
            let span = MKCoordinateSpanMake(0.009, 0.009)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude), span: span)
            mapa.setRegion(region, animated: true)
        }
        else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //ajustamos zoom al punto del usuario
        let span = MKCoordinateSpanMake(0.009, 0.009)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude), span: span)
        mapa.setRegion(region, animated: true)
        puntoB = manager.location!
        let agregar = puntoB.distance(from: puntoA)
        //print("Agregar:\(agregar), A:\(puntoA.coordinate) B:\(puntoB.coordinate)")
        total += agregar
        puntoA = puntoB

        var punto = CLLocationCoordinate2D() //generamos variable para punto
        punto.latitude = manager.location!.coordinate.latitude
        punto.longitude = manager.location!.coordinate.longitude
        
        let pin = MKPointAnnotation()
        pin.title = "Coord: \(punto.latitude), \(punto.longitude)"
                pin .subtitle = "Recorrido: \(round((total*100)/100)) metros"
        pin.coordinate = punto
        mapa.addAnnotation(pin)

    }

}

