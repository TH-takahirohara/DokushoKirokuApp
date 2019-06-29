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
        
        let totalPages: Double = Double(Int(bookData.totalPages)!)
        let lastPage: Double = Double(Int(bookData.lastPage)!)
        let rate: Double = (floor(lastPage / totalPages * 100) / 100 * 100)
        let rateStr: String = String("\(rate)")
        self.progressRateLabel.text = rateStr + "%"
    }
    
}
