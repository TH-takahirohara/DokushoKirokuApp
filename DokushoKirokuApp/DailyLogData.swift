//
//  DailyLogData.swift
//  DokushoKirokuApp
//
//  Created by 原昂大 on 2019/06/29.
//  Copyright © 2019 takahiro.hara. All rights reserved.
//

import UIKit
import Firebase

class DailyLogData: NSObject {
    var id: String?
    var date: String?
    var lastpage: String?
    
    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        self.date = valueDictionary["date"] as? String
        
        self.lastpage = valueDictionary["last_page"] as? String
    }
}
