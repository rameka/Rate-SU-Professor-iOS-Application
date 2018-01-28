//
//  TopRatedController.swift
//  
//
//  Created by Ramakrishna Sayee on 4/24/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
import UIKit

class TopRatedController:UITableViewController{
    
    struct model{
        var Name: String
        var department:String
        var rating:Double
    }
    
    var sortedProfessorArray : [ProfessorProfileStructure]!
    var modelArray = [model]()
    let professorArray = ["Swastik Brahma", "Jim Fawcett", "Howard Blair", "Andrew Lee"]
    let departmentArray = ["Computer Science","Computer Engineering","Computer Science","Chemical Engineerig"]
    let ratingArray = [4.5,3,5,5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<4 {
            let temp = model(Name: professorArray[i], department: departmentArray[i],rating: ratingArray[i])
            
            modelArray.append(temp)
        }
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255.0, green: 157/255.0, blue: 37/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func sortFunc(num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }
    
    override func viewWillAppear(animated: Bool) {

        sortedProfessorArray = profDB.profile
        sortedProfessorArray.sortInPlace { ($0.averageRating > $1.averageRating) }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return sortedProfessorArray.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TopRatedCell", forIndexPath: indexPath) as! TopRatedCell
        
        cell.professorName.text = sortedProfessorArray[indexPath.row].name
        cell.department.text = sortedProfessorArray[indexPath.row].department
        cell.value.text = String(format: "%.1f",sortedProfessorArray[indexPath.row].averageRating )
        cell.rank.text = String(indexPath.row+1)
       
        
        
        
        return cell

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
      return 100
               
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = sortedProfessorArray[indexPath.row].email.stringByReplacingOccurrencesOfString(".", withString: "-")
        CurrentProfessor.imageName = user
        CurrentProfessor.departmentName = sortedProfessorArray[indexPath.row].department
        
        // navigating to professor view controller
        let view = "ProfessorView"
        let viewcontroller = storyboard?.instantiateViewControllerWithIdentifier(view) as! ProfileViewController
        viewcontroller.indexValue = profDB.profileIndex[user]
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
    }

    
    

    
}
