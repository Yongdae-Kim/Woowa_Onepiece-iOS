/**
    AdDetailController.swift
    Author  Shanks
    Date    2016. 1. 15..
    Copyright © 2016년 Onepiece. All rights reserved.
*/

import UIKit
import Alamofire

class AdDetailController: UIViewController {
    
    @IBOutlet weak var adImgSv: UIScrollView!
    
    @IBOutlet weak var adCntPc: UIPageControl!
    
    var adModel: AdModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = adModel!.title
        
        adImgSv.pagingEnabled = true
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        for(var i=0; i<3; i++){
            let startx = CGFloat(i) * viewWidth
            let colorView = UIView(frame:CGRectMake(startx, 0, viewWidth, viewHeight))
            switch(i){
            case 0 :
                colorView.backgroundColor = UIColor.redColor()
                break
            case 1 :
                colorView.backgroundColor = UIColor.blueColor()
                break
            case 2 :
                colorView.backgroundColor = UIColor.greenColor()
                break
            default :
                break
            }
            adImgSv.addSubview(colorView)
        }
        adImgSv.contentSize = CGSizeMake(viewWidth * 3, viewHeight)
        adCntPc.numberOfPages = 3
        adCntPc.currentPage = 0
    }
    
    func scrollViewDidScroll(_scrollView: UIScrollView){
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let page = floor(_scrollView.contentOffset.x / screenWidth)
        adCntPc.currentPage = Int(page)
    }
}
