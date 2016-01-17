/**
    AdService.swift
    Author  Shanks
    Date    2016. 1. 15..
    Copyright © 2016년 Onepiece. All rights reserved.
*/

import Alamofire

class AdService {
    
    let URL_FOR_GET_AD =  "http://luffy.dev/api/ads.json"
    
    /**
        싱글톤 패턴으로 광고서비스 인스턴스를 만들어줍니다.
        @param
        @return 광고 서비스 인스턴스
    */
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
    
    /**
        광고 목록을 서버로부터 받아옵니다.
        @param  콜백
        @return 광고 목록
    */
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

    /**
        JSON NSDictionary 로부터 광고 모델을 만들어줍니다.
        @param  JSON NSDictionary
        @return 광고 모델
    */
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
    
    /**
        광고 타입 별로 필터링 된 광고 목록을 만들어줍니다.
        @param  광고타입, 광고목록
        @return 광고 목록
    */
    func getFilteredAdModelList(type : Int, adModelList : [AdModel]) -> [AdModel] {
        return adModelList.filter { (ad : AdModel) -> Bool in return ad.cdId == type }
    }
}
