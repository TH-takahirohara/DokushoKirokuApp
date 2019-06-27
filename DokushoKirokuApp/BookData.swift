//
//  BookData.swift
//  DokushoKirokuApp
//
//  Created by 原昂大 on 2019/06/27.
//  Copyright © 2019 takahiro.hara. All rights reserved.
//

import UIKit
import Firebase

class BookData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var title: String?
    var author: String?
    var totalPages: String!
    var lastPage: String!
    
    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: Data(base64Encoded: imageString!, options: .ignoreUnknownCharacters)!)
        
        self.title = valueDictionary["title"] as? String
        
        self.author = valueDictionary["author"] as? String
        
        self.totalPages = valueDictionary["total_pages"] as? String
        
        self.lastPage = valueDictionary["last_page"] as? String
    }
    
    
}
