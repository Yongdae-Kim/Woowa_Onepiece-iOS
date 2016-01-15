//
//  AdDetailController.swift
//  Shanks
//
//  Created by user on 2016. 1. 15..
//  Copyright © 2016년 Onepiece. All rights reserved.
//

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
        
//        for(var i=0; i<3; i++){
//            let startx = CGFloat(i).
//        }
        
    }
}
