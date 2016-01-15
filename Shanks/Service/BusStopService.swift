//
//  BusStopService.swift
//  Shanks
//
//  Created by user on 2016. 1. 15..
//  Copyright © 2016년 Onepiece. All rights reserved.
//
import Alamofire

class BusStopService {
    
    let URL_FOR_GET_BUS_STOP =  "http://luffy.dev/api/bus_stops.json"
    
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
