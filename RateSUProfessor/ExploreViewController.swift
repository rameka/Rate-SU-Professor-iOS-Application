//
//  ExploreViewController.swift
//  
//
//  Created by Ramakrishna Sayee on 4/19/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase


class ExploreViewController: UITableViewController, UISearchBarDelegate{
    
    enum selectedScope:Int {
        case name = 0
        case department = 1
        
    }

    let initialDataAry = Model.generateArray()
    var dataArray = Model.generateArray()
    
    
    @IBOutlet weak var DisplayImage: UIImageView!
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetup()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255.0, green: 157/255.0, blue: 37/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        Model.updateDB()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        //self.navigationController?.navigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        dataArray = Model.generateArray()
        self.tableView.reloadData()
    }
    
    func searchBarSetup() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        
        searchBar.barTintColor = UIColor.init(red: 255/255.0, green: 157/255.0, blue: 37/255.0, alpha: 1)
        searchBar.placeholder = "Find your favourite professor"
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name","Department"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchBar
        
        self.tableView.tableHeaderView?.tintColor = UIColor.whiteColor()
        
        
    }
    
    func searchBar(_searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            dataArray = initialDataAry
            self.tableView.reloadData()
        }else {
            filterTableView(_searchBar.selectedScopeButtonIndex, text: searchText)
          
        }
    }
    
    func filterTableView(ind:Int,text:String) {
        switch ind {
        case selectedScope.name.rawValue:
            //fix of not searching when backspacing
            dataArray = initialDataAry.filter({ (mod) -> Bool in
                //return mod.profName.lowercased().contains(text.lowercased())
                return mod.profName.lowercaseString.containsString(text.lowercaseString)
            })
            self.tableView.reloadData()
        case selectedScope.department.rawValue:
            //fix of not searching when backspacing
            dataArray = initialDataAry.filter({ (mod) -> Bool in
                //return mod.profDepartment.lowercased().contains(text.lowercased())
                return mod.profDepartment.lowercaseString.containsString(text.lowercaseString)
            })
            self.tableView.reloadData()
        
        default:
            print("no type")
        }
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows : \(dataArray.count)")
        return dataArray.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCellWithIdentifier("searchcell", forIndexPath: indexPath) as! SearchCustomCell
        let model = dataArray[indexPath.row]
        cell.updateImage()
        cell.picture.image = UIImage(named: model.imageName)
        cell.Department.text=model.profDepartment
        cell.Name.text = model.profName
       cell.designation.text = model.profDesignation
        
        return cell
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        CurrentProfessor.imageName = dataArray[indexPath.row].imageName
        CurrentProfessor.profName = dataArray[indexPath.row].profName
        CurrentProfessor.departmentName = dataArray[indexPath.row].profDepartment
        
        let view = "ProfessorView"
        let viewcontroller = storyboard?.instantiateViewControllerWithIdentifier(view) as! ProfileViewController
        viewcontroller.indexValue = profDB.profileIndex[dataArray[indexPath.row].imageName]
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
        
        
    }
}
