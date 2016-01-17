/**
    BusStopController.swift
    Author  Shanks
    Date    2016. 1. 12..
    Copyright © 2016년 Onepiece. All rights reserved.
*/

import MapKit
import UIKit
import Alamofire

class BusStopController: UIViewController {
    
    let TITLE_NAME = "정류장 지도 보기"
    
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
    
    /**
        네비게이션 바, 텍스트 필드, 버튼을 초기화합니다.
        @param
        @return
    */
    private func viewInit(){
        self.navigationItem.title = TITLE_NAME

        Theme.sharedInstance.initTfBorderColor(searchTf)
        Theme.sharedInstance.initBtnTextColor(searchBtn)
        
        searchBtn.addTarget(self, action: Selector("btnPressed:"), forControlEvents: UIControlEvents.TouchDown);
    }
    
    func btnPressed(sender : UIButton!) {
        let searchText: String = searchTf.text!
        showSelectedAnnotation(searchText)
    }
    
    /**
        맵 위에 버스정류장 마커를 만들어준다.
        @param  버스정류장 목록
        @return
    */
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
    
    /**
        어노테이션 Dictionary 에서 키 값으로 해당 어노테이션 찾아서 맵위에 보여준다.
        @param  어노테이션 Dictionary 키 값
        @return
    */
    private func showSelectedAnnotation(searchText: String){
        if let selectedAnnotaion = anntationDic[searchText] {
            map.selectAnnotation(selectedAnnotaion, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}