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
   
    func test(){
        print("protocol test");
    }
    
    let TITLE_NAME = "광고 목록 보기"
    let URL_FOR_GET_AD =  "http://luffy.dev/api/ads.json"
        
    let MY_COLOR : UIColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    let TYPE_DIC : [String: Int] = [
        "음식": 1,
        "문화": 2,
        "매장": 3,
        "기타": 4
    ]
    
    @IBOutlet weak var etcBtn: UIButton!
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var cultureBtn: UIButton!
    @IBOutlet weak var foodBtn: UIButton!
    @IBOutlet weak var totalBtn: UIButton!
    
    @IBOutlet weak var adTableView: UITableView!
    
   
    var adList = [AdModel]()
    var adTableList = [AdModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TITLE_NAME
        showAdTableView()
        
        btnsInit([totalBtn, foodBtn, cultureBtn, storeBtn, etcBtn])
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
                self.adList = self.adTableList
                self.adTableView.reloadData()
            }
        }
    }
    
    func genreateAdList(dict : NSDictionary){
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
        self.adTableList.append(adModel)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adTableList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AdCell", forIndexPath: indexPath) as! AdTableCell
        
        let row = indexPath.row
        cell.adTitle.text = adTableList[row].title
        cell.adComment.text = adTableList[row].comment1
        
        let img = UIImage(named: "sample.jpg")
        cell.adImg.image = img
        cell.adImg.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AdDetailSegue") {
            let adDetailController = segue.destinationViewController as! AdDetailController
            let row = (self.adTableView.indexPathForSelectedRow?.row)!
            adDetailController.adModel = adTableList[row]
        }
    }
    
    private func btnsInit(btns : [UIButton]){
        for btn in btns {
            btn.backgroundColor = UIColor.clearColor()
            btn.layer.cornerRadius = 8.0
            btn.layer.masksToBounds = true
            btn.layer.borderWidth = 2.0
            btn.layer.borderColor = MY_COLOR.CGColor
            btn.setTitleColor(MY_COLOR, forState: UIControlState.Normal)
            btn.addTarget(self, action: Selector("btnPressed:"), forControlEvents: UIControlEvents.TouchDown);
        }
    }
    
    func btnPressed(sender : UIButton!) {
        adTableList = adList
        if(sender != totalBtn){
            let key = sender.titleLabel!.text
            adTableList = getFilteredAdTableList(TYPE_DIC[key!]!)
        }
        self.adTableView.reloadData()
    }

    private func getFilteredAdTableList(type : Int) -> [AdModel] {
        return adTableList.filter { (ad : AdModel) -> Bool in return ad.cdId == type }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
