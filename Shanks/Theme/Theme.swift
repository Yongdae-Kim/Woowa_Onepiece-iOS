/**
    ThemeUtil.swift
    Author  Shanks
    Date    2016. 1. 17..
    Copyright © 2016년 Onepiece. All rights reserved.
*/

import UIKit
import Alamofire

class Theme {

    let MY_COLOR : UIColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    
    /**
        싱글톤 패턴으로 테마 인스턴스를 만들어줍니다.
        @param
        @return 테마 인스턴스
    */
    class var sharedInstance: Theme {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Theme? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Theme()
        }
        return Static.instance!
    }
    
    /**
        네비게이션 바, 텍스트 색상을 설정한다.
        @param
        @return
    */
    func initNaviBarColor(){
        UINavigationBar.appearance().barTintColor = MY_COLOR
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }

    /**
        텝 바, 텍스트 색상을 설정한다.
        @param
        @return
    */
    func initTabBarColor(){
        UITabBar.appearance().barTintColor = MY_COLOR
        UITabBar.appearance().tintColor = UIColor.whiteColor()
    }
    
    /**
        텍스트 필드 테두리 색상을 설정한다.
        @param
        @return 텍스트 필드
    */
    func initTfBorderColor(tf: UITextField){
        tf.backgroundColor = UIColor.clearColor()
        tf.layer.cornerRadius = 8.0
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 2.0
        tf.layer.borderColor = MY_COLOR.CGColor
    }
    
    /**
        버튼 텍스트 색상을 설정한다.
        @param
        @return 버튼
    */
    func initBtnTextColor(btn: UIButton){
       btn.setTitleColor(MY_COLOR, forState: UIControlState.Normal)
    }
    
    /**
        버튼 테두리 색상을 설정한다.
        @param
        @return 버튼
    */
    func initBtnBoarderColor(btn: UIButton){
        btn.backgroundColor = UIColor.clearColor()
        btn.layer.cornerRadius = 8.0
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 2.0
        btn.layer.borderColor = MY_COLOR.CGColor
    }
}
