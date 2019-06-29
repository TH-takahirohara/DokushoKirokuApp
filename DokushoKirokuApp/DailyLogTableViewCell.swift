//
//  DailyLogTableViewCell.swift
//  DokushoKirokuApp
//
//  Created by 原昂大 on 2019/06/29.
//  Copyright © 2019 takahiro.hara. All rights reserved.
//

import UIKit

class DailyLogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDailyLogData(_ dailyLogData: DailyLogData) {
        self.dateLabel.text = dailyLogData.date!
        self.progressLabel.text = dailyLogData.lastpage! + " ページまで読了"
    }
    
}
