/**
    AdDetailController.swift
    Author  Shanks
    Date    2016. 1. 15..
    Copyright © 2016년 Onepiece. All rights reserved.
*/

import UIKit
import Alamofire

class AdDetailController: UIViewController {
    
    @IBOutlet weak var adImgCtView: UIView!
    @IBOutlet weak var adImgSv: UIScrollView!
    @IBOutlet weak var adCntPc: UIPageControl!
    
    @IBOutlet weak var adCt1L: UILabel!
    @IBOutlet weak var adCt2L: UILabel!
    @IBOutlet weak var adAddrL: UILabel!
    @IBOutlet weak var adLocBtn: UIButton!
    
    var adModel: AdModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInit()
    }
    
    func viewInit(){
        self.navigationItem.title = adModel!.title!
        adImgContentViewInit((adModel?.imgModelList)!)
        adCt1L.text = adModel?.comment1
        adCt2L.text = adModel?.comment2
        adAddrL.text = adModel?.locModel?.addr
        
        Theme.sharedInstance.initBtnBoarderColor(adLocBtn)
        Theme.sharedInstance.initBtnTextColor(adLocBtn)
        adLocBtn.addTarget(self, action: Selector("btnPressed:"), forControlEvents: UIControlEvents.TouchDown);
    }
    
    func btnPressed(sender : UIButton!) {
        let locModel = adModel?.locModel
        print(locModel!.lat)
        print(locModel!.lng)
    }
    
    func adImgContentViewInit(imgModelList: [ImgModel]){
        
        adImgSv.pagingEnabled = true
        let viewWidth = self.adImgCtView.frame.size.width
        let viewHeight = self.adImgCtView.frame.size.height
        let imgsCnt = imgModelList.count
                
        for(var i=0; i<imgsCnt; i++){
            let startx = CGFloat(i) * viewWidth
            let colorView = UIView(frame:CGRectMake(startx, 0, viewWidth, viewHeight))
            
            Alamofire.request(.GET, imgModelList[i].uri!).response() {
                (_, _, data, _) in
                colorView.backgroundColor = UIColor(patternImage: UIImage(data: data!)!)
            }
            adImgSv.addSubview(colorView)
        }
        adImgSv.contentSize = CGSizeMake(viewWidth * CGFloat(imgsCnt), viewHeight)
        adCntPc.numberOfPages = imgsCnt
        adCntPc.currentPage = 0
    }
    
    func scrollViewDidScroll(_scrollView: UIScrollView){
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let page = floor(_scrollView.contentOffset.x / screenWidth)
        adCntPc.currentPage = Int(page)
    }
}
