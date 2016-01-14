//
//  SecondViewController.swift
//  Shanks
//
//  Created by user on 2016. 1. 12..
//  Copyright © 2016년 Onepiece. All rights reserved.
//

import MapKit
import UIKit
import Alamofire

class BusStopController: UIViewController {
    
   
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    let URL_FOR_GET_BUS_STOP =  "http://luffy.dev/api/bus_stops.json"
    var busStopList = [BusStopModel]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "정류장 지도 보기"
        
        let myColor : UIColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        
        searchTf.layer.cornerRadius = 8.0
        searchTf.layer.masksToBounds = true
        searchTf.layer.borderWidth = 2.0
        searchTf.layer.borderColor = myColor.CGColor
        
        searchBtn.setTitleColor(myColor, forState: UIControlState.Normal)
        
        showBusStopMarkerOnMap();
    }
    
    func showBusStopMarkerOnMap(){
        Alamofire.request(.GET, URL_FOR_GET_BUS_STOP).responseJSON { response in
            let JSON = response.result.value
            if let busStops = JSON as? NSArray {
                for busStop in busStops {
                    if let dict = busStop as? NSDictionary {
                         self.genreateBusStopList(dict)
                    }
                }
                self.genreateBusStopMarker();
            }
        }
    }
    
    func genreateBusStopList(dict : NSDictionary){
        let busStopModel = BusStopModel()
        
        busStopModel.id = dict["id"] as? Int
        busStopModel.key = dict["key"] as? String
        busStopModel.name = dict["name"] as? String
        busStopModel.adsCnt = dict["ads_cnt"] as? Int
        
        if let loc = dict["loc"] {
            let locModel = LocModel()
            locModel.addr = loc["addr"] as? String
            locModel.lat = loc["lat"] as? String
            locModel.lng = loc["lng"] as? String
            busStopModel.locModel = locModel
        }
        self.busStopList.append(busStopModel)
    }
    
    func genreateBusStopMarker(){
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        
        for busStop in busStopList {
            
            let lat = Double(busStop.locModel!.lat!)
            let lng = Double(busStop.locModel!.lng!)
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            map.setRegion(region, animated: true)
            
            let anotation = MKPointAnnotation()
            anotation.coordinate = location
            anotation.title = busStop.name
            anotation.subtitle = busStop.locModel!.addr! + " / " + String(busStop.adsCnt!)
            map.addAnnotation(anotation)
        }
    }
    
    @IBAction func searchBtnPressed(sender: AnyObject) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}