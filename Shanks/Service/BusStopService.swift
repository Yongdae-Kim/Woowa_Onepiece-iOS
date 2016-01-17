/**
    BusStopService.swift
    Author  Shanks
    Date    2016. 1. 15..
    Copyright © 2016년 Onepiece. All rights reserved.
*/

import Alamofire

class BusStopService {
    
    let URL_FOR_GET_BUS_STOP =  "http://luffy.dev/api/bus_stops.json"
    
    /**
        싱글톤 패턴으로 광고서비스 인스턴스를 만들어줍니다.
        @param
        @return 광고 서비스 인스턴스
    */
    class var sharedInstance: BusStopService {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: BusStopService? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = BusStopService()
        }
        return Static.instance!
    }

    /**
        버스 정류장 목록을 서버로부터 받아옵니다.
        @param  콜백
        @return 버스정류장 목록
    */
    func getBusStopList(completionHandler:[BusStopModel] -> ())  {
        Alamofire.request(.GET, URL_FOR_GET_BUS_STOP).responseJSON {
            response in
            let JSON = response.result.value
            var busStopList = [BusStopModel]()
            
            if let busStops = JSON as? NSArray {
                for busStop in busStops {
                    if let dict = busStop as? NSDictionary {
                        let busStopModel = self.genreateBusStopModel(dict)
                        busStopList.append(busStopModel)
                    }
                }
                completionHandler(busStopList)
            }
        }
    }
    
    /**
        JSON NSDictionary 로부터 버스 정류장 모델을 만들어줍니다.
        @param  JSON NSDictionary
        @return 버스 정류장 모델
    */
    private func genreateBusStopModel(dict : NSDictionary) -> BusStopModel{
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
        
        return busStopModel
    }
}
