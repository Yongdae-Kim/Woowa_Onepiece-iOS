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
    
    let TITLE_NAME = "정류장 지도 보기"
    let URL_FOR_GET_BUS_STOP =  "http://luffy.dev/api/bus_stops.json"
    let MY_COLOR : UIColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
   
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    var busStopList = [BusStopModel]()
    var anntationDic = [String: MKPointAnnotation]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TITLE_NAME
        
        searchTf.layer.cornerRadius = 8.0
        searchTf.layer.masksToBounds = true
        searchTf.layer.borderWidth = 2.0
        searchTf.layer.borderColor = MY_COLOR.CGColor
        
        searchBtn.setTitleColor(MY_COLOR, forState: UIControlState.Normal)
        
        showBusStopMarkerOnMap();
        
     //   let busStopService = BusStopService()
     //   let busStopList = busStopService.getBusStopList()
     //   genreateBusStopMarker()
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
                self.genreateBusStopMarker()
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
            anotation.title = busStop.name! + " (" + String(busStop.adsCnt!) + ")"
            anotation.subtitle = busStop.locModel!.addr!
        
            map.addAnnotation(anotation)
            
            anntationDic[busStop.name!] = anotation
        }
        
        showSelectedAnnotation(anntationDic.keys.first!)
    }
    
    @IBAction func searchBtnPressed(sender: AnyObject) {
        let searchText: String = searchTf.text!
        showSelectedAnnotation(searchText)
    }
    
    func showSelectedAnnotation(searchText: String){
        if let selectedAnnotaion = anntationDic[searchText] {
            map.selectAnnotation(selectedAnnotaion, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}