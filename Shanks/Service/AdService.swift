//
//  AdService.swift
//  Shanks
//
//  Created by user on 2016. 1. 15..
//  Copyright © 2016년 Onepiece. All rights reserved.
//

import Alamofire

class AdService {
    
    let URL_FOR_GET_AD =  "http://luffy.dev/api/ads.json"
    
    class var sharedInstance: AdService {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AdService? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AdService()
        }
        return Static.instance!
    }
    
    func getAdList(completionHandler:[AdModel] -> ())  {
        Alamofire.request(.GET, URL_FOR_GET_AD).responseJSON {
            response in
            let JSON = response.result.value
            var adModelList = [AdModel]()
            
            if let busStops = JSON as? NSArray {
                for busStop in busStops {
                    if let dict = busStop as? NSDictionary {
                        let adModel = self.genreateAdModel(dict)
                        adModelList.append(adModel)
                    }
                }
                completionHandler(adModelList)
            }
        }
    }
    
    private func genreateAdModel(dict : NSDictionary) -> AdModel{
        let adModel = AdModel()
        
        adModel.id = dict["id"] as? Int
        adModel.cdId = dict["cd_id"] as? Int
        adModel.title = dict["title"] as? String
        adModel.comment1 = dict["content1"] as? String
        adModel.comment2 = dict["content2"] as? String
        adModel.startDt = dict["start_dt"] as? String
        adModel.endDt = dict["end_dt"] as? String
        
        if let loc = dict["loc"] {
            let locModel = LocModel()
            locModel.addr = loc["addr"] as? String
            locModel.lat = loc["lat"] as? String
            locModel.lng = loc["lng"] as? String
            adModel.locModel = locModel
        }
        return adModel
    }
    
    func getFilteredAdModelList(type : Int, adModelList : [AdModel]) -> [AdModel] {
        return adModelList.filter { (ad : AdModel) -> Bool in return ad.cdId == type }
    }
}
