//
//  BookTableViewCell.swift
//  DokushoKirokuApp
//
//  Created by 原昂大 on 2019/06/27.
//  Copyright © 2019 takahiro.hara. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var progressRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBookData(_ bookData: BookData) {
        self.bookImageView.image = bookData.image
        self.titleLabel.text = bookData.title
        self.authorLabel.text = bookData.author
        
        let totalPages: Int = Int(bookData.totalPages)!
        let lastPage: Int = Int(bookData.lastPage)!
        let rate: Double = (floor(Double(lastPage / totalPages * 10)) / 10) as! Double
        let rateStr: String = String("\(rate)")
        self.progressRateLabel.text = rateStr + "%"
    }
    
}
