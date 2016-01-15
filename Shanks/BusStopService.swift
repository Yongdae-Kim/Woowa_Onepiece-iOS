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
    
    func getBusStopList() -> [BusStopModel] {
        var busStopList = [BusStopModel]()
        Alamofire.request(.GET, URL_FOR_GET_BUS_STOP).responseJSON { response in
            let JSON = response.result.value
            if let busStops = JSON as? NSArray {
                for busStop in busStops {
                    if let dict = busStop as? NSDictionary {
                        let busStopModel = self.genreateBusStopModel(dict)
                        busStopList.append(busStopModel)
                        print(busStopList)
                    }
                }
            }
        }
        return busStopList
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
