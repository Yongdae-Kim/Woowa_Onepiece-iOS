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
    let MY_COLOR : UIColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
   
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    var anntationDic = [String: MKPointAnnotation]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInit()
       
        BusStopService.sharedInstance.getBusStopList({
            completion in self.genreateBusStopMarker(completion)
            self.showSelectedAnnotation(self.anntationDic.keys.first!)
        })
    }
    
    private func viewInit(){
        self.navigationItem.title = TITLE_NAME

        searchTf.layer.cornerRadius = 8.0
        searchTf.layer.masksToBounds = true
        searchTf.layer.borderWidth = 2.0
        searchTf.layer.borderColor = MY_COLOR.CGColor
        
        searchBtn.setTitleColor(MY_COLOR, forState: UIControlState.Normal)
    }
    
    private func genreateBusStopMarker(busStopModelList: [BusStopModel]){
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        
        for busStopModel in busStopModelList {
            
            let lat = Double(busStopModel.locModel!.lat!)
            let lng = Double(busStopModel.locModel!.lng!)
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            map.setRegion(region, animated: true)
            
            let anotation = MKPointAnnotation()
            anotation.coordinate = location
            anotation.title = busStopModel.name! + " (" + String(busStopModel.adsCnt!) + ")"
            anotation.subtitle = busStopModel.locModel!.addr!
        
            map.addAnnotation(anotation)
            
            anntationDic[busStopModel.name!] = anotation
        }
    }
    
    @IBAction func searchBtnPressed(sender: AnyObject) {
        let searchText: String = searchTf.text!
        showSelectedAnnotation(searchText)
    }
    
    private func showSelectedAnnotation(searchText: String){
        if let selectedAnnotaion = anntationDic[searchText] {
            map.selectAnnotation(selectedAnnotaion, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}