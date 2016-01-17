/**
    AdModel.swift
    Author  Shanks
    Date    2016. 1. 13..
    Copyright © 2016년 Onepiece. All rights reserved.
*/

import UIKit

class AdModel: NSObject {
    var id: Int?
    var title: String?
    var cdId: Int?
    var comment1: String?
    var comment2: String?
    var startDt: String?
    var endDt: String?
    var locModel: LocModel?
    var imgModelList: [ImgModel]?
}