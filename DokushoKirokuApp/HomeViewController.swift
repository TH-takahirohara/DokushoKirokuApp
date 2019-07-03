//
//  HomeViewController.swift
//  DokushoKirokuApp
//
//  Created by 原昂大 on 2019/06/25.
//  Copyright © 2019 takahiro.hara. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bookArray: [BookData] = []
    
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
            let currentUserId = Auth.auth().currentUser?.uid
            if self.observing == false {
                let booksRef = Database.database().reference().child("user/" + currentUserId! + "/book")
                booksRef.observe(.childAdded, with: {snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    let bookData = BookData(snapshot: snapshot)
                    self.bookArray.insert(bookData, at: 0)
                    
                    self.tableView.reloadData()
                })
                
                booksRef.observe(.childChanged, with: {snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    let bookData = BookData(snapshot: snapshot)
                    
                    var index: Int = 0
                    for book in self.bookArray {
                        if book.id == bookData.id {
                            index = self.bookArray.firstIndex(of: book)!
                            break
                        }
                    }
                    
                    self.bookArray.remove(at: index)
                    
                    self.bookArray.insert(bookData, at: index)
                    
                    self.tableView.reloadData()
                })
                
                observing = true
            }
        } else {
            if observing == true {
                let currentUserId = Auth.auth().currentUser?.uid
                bookArray = []
                tableView.reloadData()
                
                let booksRef = Database.database().reference().child("user/" + currentUserId! + "/book")
                booksRef.removeAllObservers()
                
                observing = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BookTableViewCell
        cell.setBookData(bookArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentUserId = Auth.auth().currentUser?.uid
            if Auth.auth().currentUser != nil {
                let bookData = bookArray[indexPath.row]
                let booksRef = Database.database().reference().child("user/" + currentUserId! + "/book/" + bookData.id!)
                booksRef.removeValue()
                
                let dailyLogsRef = Database.database().reference().child("user/" + currentUserId! + "/dailylog/" + bookData.id!)
                dailyLogsRef.removeValue()
                
                bookArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellSegue" {
            let cellViewController: CellViewController = segue.destination as! CellViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            cellViewController.bookData = bookArray[indexPath!.row]
        }
    }

    @IBAction func unwindHandleLogoutButton(_ segue: UIStoryboardSegue) {
        if Auth.auth().currentUser != nil {
            try! Auth.auth().signOut()
            
            bookArray = []
            observing = false
            
            UIView.animate(
                withDuration: 0.0,
                animations: {
                    self.tableView.reloadData()
                }, completion: { finished in
                    if (finished) {
                        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                        self.present(loginViewController!, animated: true, completion: nil)
                    }
                }
            )
        }
    }
    
    @IBAction func unwindHandleDeleteAccountButton(_ segue: UIStoryboardSegue) {
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            let currentUserId = Auth.auth().currentUser?.uid
            
            user?.delete { error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                } else {
                    print("DEBUG_PRINT: ユーザー削除に成功しました。")
                }
            }
            
            let userRef = Database.database().reference().child("user/" + currentUserId!)
            userRef.removeValue()
            
            bookArray = []
            observing = false
            
            UIView.animate(
                withDuration: 0.0,
                animations: {
                    self.tableView.reloadData()
                }, completion: { finished in
                    if (finished) {
                        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                        self.present(loginViewController!, animated: true, completion: nil)
                    }
                }
            )
        }
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
