//
//  FirstView.swift
//  Shanks
//
//  Created by user on 2016. 1. 12..
//  Copyright © 2016년 Onepiece. All rights reserved.
//

import UIKit
import Alamofire

class AdTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adComment: UILabel!
    @IBOutlet weak var adImg: UIImageView!
}

class AdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var adList = [AdModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "http://luffy.dev/api/ads.json").responseJSON { response in

            // print(response.request)  // original URL request
            // print(response.response) // URL response
            // print(response.result)   // result of response serialization
            
            let JSON = response.result.value
            if let ads = JSON as? NSArray {
                for ad in ads {
                    if let dict = ad as? NSDictionary {
                        print(dict["ad_imgs"] as? NSObject)
                        
                        let adModel = AdModel()
                        
                        adModel.id = dict["id"] as? Int
                        adModel.title = dict["ad_title"] as? String
                        adModel.addr = dict["ad_addr"] as? String
                        adModel.lng = dict["ad_lng"] as? String
                        adModel.lat = dict["ad_lat"] as? String
                        adModel.comment1 = dict["ad_ct1"] as? String
                        adModel.comment2 = dict["ad_ct2"] as? String
                        adModel.startDt = dict["ad_start_dt"] as? String
                        adModel.endDt = dict["ad_end_dt"] as? String
                        
                        self.adList.append(adModel)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AdCell", forIndexPath: indexPath) as! AdTableViewCell

        let row = indexPath.row
        cell.adTitle.text = adList[row].title
        cell.adComment.text = adList[row].comment1
        
        let img = UIImage(named: "sample.jpg")
        cell.adImg.image = img
        cell.adImg.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // let row = indexPath.row
        // let order = adList[row].title
    }
}
