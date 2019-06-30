//
//  CellViewController.swift
//  DokushoKirokuApp
//
//  Created by 原昂大 on 2019/06/25.
//  Copyright © 2019 takahiro.hara. All rights reserved.
//

import UIKit
import Firebase

class CellViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var progressRateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var bookData: BookData!
    
    var dailyLogArray: [DailyLogData] = []
    
    var observing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "DailyLogTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension

        bookImageView.image = bookData.image
        titleLabel.text = bookData.title
        authorLabel.text = bookData.author
        
        let totalPages: Double = Double(Int(bookData.totalPages)!)
        let lastPage: Double = Double(Int(bookData.lastPage)!)
        let rate: Double = (floor(lastPage / totalPages * 1000) / 1000 * 100)
        let rateStr: String = String("\(rate)")
        self.progressRateLabel.text = rateStr + "% (\(lastPage) / \(totalPages))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellInputSegue" {
            let cellInputViewController: CellInputViewController = segue.destination as! CellInputViewController
            cellInputViewController.bookData = self.bookData
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentUserId = Auth.auth().currentUser?.uid
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                let dailyLogsRef = Database.database().reference().child("user/" + currentUserId! + "/dailylog/" + bookData.id!)
                dailyLogsRef.observe(.childAdded, with: {snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    let dailyLogData = DailyLogData(snapshot: snapshot)
                    self.dailyLogArray.append(dailyLogData)
                    
                    self.tableView.reloadData()
                })
                
                observing = true
            }
            
            let bookRef = Database.database().reference().child("user/" + currentUserId! + "/book/")
            bookRef.observe(.childChanged, with: {snapshot in
                print("DEBUG_PRINT: .childChangedイベント(Book)が発生しました。")
                
                let newBookData = BookData(snapshot: snapshot)
                self.bookData = newBookData
                
                let totalPages: Double = Double(Int(self.bookData.totalPages)!)
                let lastPage: Double = Double(Int(self.bookData.lastPage)!)
                let rate: Double = (floor(lastPage / totalPages * 1000) / 1000 * 100)
                let rateStr: String = String("\(rate)")
                self.progressRateLabel.text = rateStr + "% (\(lastPage) / \(totalPages))"
                
            })
        } else {
            if observing == true {
                dailyLogArray = []
                tableView.reloadData()
                
                let dailyLogsRef = Database.database().reference().child("user/" + currentUserId! + "/book")
                dailyLogsRef.removeAllObservers()
                
                observing = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyLogArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DailyLogTableViewCell
        cell.setDailyLogData(dailyLogArray[indexPath.row])
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
