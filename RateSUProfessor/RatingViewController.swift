//
//  RatingViewController.swift
//
//
//  Created by Ramakrishna Sayee on 4/22/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
import UIKit



class RatingViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet weak var headerLabel: UILabel!
    var Index:Int? {
        didSet {
            configureView2()
        }
    }
    
    
    var headerString:String? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        headerLabel.text = headerString
    }

    var reviews = [RateViewController.Review()]
    
    func configureView2() {

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profDB.profile[Index!].ratings.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Review", forIndexPath: indexPath) as! ReviewCell
        cell.comment?.editable = false
        cell.reviewTitle?.text = profDB.profile[Index!].ratings[indexPath.row].commentTitle
        cell.cNameAndcNumber?.text = "\(profDB.profile[Index!].ratings[indexPath.row].courseNumber) \(profDB.profile[Index!].ratings[indexPath.row].courseName)"
        

       cell.difficultValue?.text = profDB.profile[Index!].ratings[indexPath.row].difficultyLevel
     
        
 
        cell.comment?.text = profDB.profile[Index!].ratings[indexPath.row].comment
        
        let starValue = profDB.profile[Index!].ratings[indexPath.row].ratingValue
        cell.starDisplay(Int(starValue)!)
        
        return cell
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        // Dynamic adjusting the cell size
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    
}
