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
        
        let totalPages: NSDecimalNumber = NSDecimalNumber(string: bookData.totalPages)
        let lastPage: NSDecimalNumber = NSDecimalNumber(string: bookData.lastPage)
        let behaviors: NSDecimalNumberHandler = NSDecimalNumberHandler(
            roundingMode: .down,
            scale: 1,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false)
        let rate: NSDecimalNumber = lastPage.dividing(by: totalPages).multiplying(by: NSDecimalNumber(string: "100"))
        let roundingRate = rate.rounding(accordingToBehavior: behaviors)
        self.progressRateLabel.text = "\(roundingRate)" + "%"
    }
    
}
