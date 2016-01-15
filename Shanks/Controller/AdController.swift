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
    
    @IBOutlet weak var adTitleL: UILabel!
    
    @IBOutlet weak var adImgIv: UIImageView!
    
    @IBOutlet weak var adCommentL: UILabel!
}

class AdController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
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
        viewInit();
        
        AdService.sharedInstance.getAdList({
            completion in self.initAdList(completion)
        })
    }
    
    func initAdList(adModelList: [AdModel] ){
        self.adTableList = adModelList
        self.adList = adModelList
        self.adTableView.reloadData()
    }
    
    private func viewInit(){
        self.navigationItem.title = TITLE_NAME
        btnsInit([totalBtn, foodBtn, cultureBtn, storeBtn, etcBtn])
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
            let type = TYPE_DIC[key!]
            adTableList = AdService.sharedInstance.getFilteredAdModelList(type!, adModelList: adTableList)
        }
        self.adTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adTableList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AdCell", forIndexPath: indexPath) as! AdTableCell
        
        let row = indexPath.row
        cell.adTitleL.text = adTableList[row].title
        cell.adCommentL.text = adTableList[row].comment1
        
        let img = UIImage(named: "/resources/sample.jpg")
        cell.adImgIv.image = img
        cell.adImgIv.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("AdDetailSegue", sender: cell)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AdDetailSegue") {
            let adDetailController = segue.destinationViewController as! AdDetailController
            let row = self.adTableView.indexPathForSelectedRow!.row
            adDetailController.adModel = adTableList[row]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
