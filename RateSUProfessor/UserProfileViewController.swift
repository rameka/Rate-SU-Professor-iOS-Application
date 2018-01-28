//
//  UserProfileViewController.swift
//  RateSUProfessor
//
//  Created by Jegan Gopalakrishnan on 4/22/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserProfileViewController: UITableViewController {
    
    // This array is used for populating the section headers
    let sectionTitle = ["Name", "My School", "Year Of Graduation", "Major", "My Account"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom:0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
     //Asks the data source to return the header string for the section
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("SectionHeader") as! SectionHeaderCell
        cell.Label.text = sectionTitle[section]
        return cell

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if( indexPath.section == 4)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("LastCell", forIndexPath: indexPath) as! LastCell
            cell.emailLabel.text = DatabaseController.userProfile.emailId
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCustomCell
        cell.sectionIndex = indexPath.section
        cell.TextField.enabled = false
        // Populating the section cells with user related content
        switch indexPath.section {
        case 0:
            cell.TextField.text = DatabaseController.userProfile.name
        case 1:
            cell.TextField.text = DatabaseController.userProfile.university
        case 2:
            cell.TextField.text = String(DatabaseController.userProfile.yearOfGraduation)
        case 3:
            cell.TextField.text = DatabaseController.userProfile.major
        default:
            print("Default case")
        }
        return cell

    }
    // Setting the height of cell
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 4)
        {
            return 120
        }
        else{
            return 50
            
        }
    }
    
}
