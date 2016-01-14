//
//  FirstView.swift
//  Shanks
//
//  Created by user on 2016. 1. 12..
//  Copyright © 2016년 Onepiece. All rights reserved.
//

import UIKit
import Alamofire

class AdTableCell: UITableViewCell {
    
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adComment: UILabel!
    @IBOutlet weak var adImg: UIImageView!
}

class AdController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    let URL_FOR_GET_AD =  "http://luffy.dev/api/ads.json"
    let myColor : UIColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var etcBtn: UIButton!
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var cultureBtn: UIButton!
    @IBOutlet weak var foodBtn: UIButton!
    
    @IBOutlet weak var adTableView: UITableView!
    
    var adList = [AdModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "광고 목록 보기"
        showAdTableView()
        
        btnInit(foodBtn)
        btnInit(cultureBtn)
        btnInit(storeBtn)
        btnInit(etcBtn)
    }
    
    
    func showAdTableView(){
        Alamofire.request(.GET, URL_FOR_GET_AD).responseJSON { response in
            
            let JSON = response.result.value
            if let ads = JSON as? NSArray {
                for ad in ads {
                    if let dict = ad as? NSDictionary {
                        self.genreateAdList(dict)
                    }
                }
                self.adTableView.reloadData()
            }
        }
    }
    
    func genreateAdList(dict : NSDictionary){
        let adModel = AdModel()
        
        adModel.id = dict["id"] as? Int
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
        self.adList.append(adModel)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AdCell", forIndexPath: indexPath) as! AdTableCell
        
        let row = indexPath.row
        cell.adTitle.text = adList[row].title
        cell.adComment.text = adList[row].comment1
        
        let img = UIImage(named: "sample.jpg")
        cell.adImg.image = img
        cell.adImg.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        let row = indexPath.row
    //        let order = adList[row].title
    //    }
    
    func btnInit(btn : UIButton){
        btn.backgroundColor = UIColor.clearColor()
        btn.layer.cornerRadius = 8.0
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 2.0
        btn.layer.borderColor = myColor.CGColor
        btn.setTitleColor(myColor, forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
