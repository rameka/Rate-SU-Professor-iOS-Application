//
//  StackElementProfileController.swift
//  
//
//  Created by Ramakrishna Sayee on 4/19/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation

import UIKit

class StackElementProfileController: UIViewController{
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var degreeText: UITextView!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var roomNumber: UILabel!
    @IBOutlet weak var teachingText: UITextView!
    
    @IBOutlet weak var currentResearchText: UITextView!
    
    @IBOutlet weak var publicationsText: UITextView!
    
    var Index:Int? {
        didSet {
            configureTextView()
        }
    }
    var headerString:String? {
        didSet {
            configureView()
        }
    }
    
    // configures the header label when view loads
    func configureView() {
        headerLabel.text = headerString
    }
    // Sets the values for profile tab in professor profile view
    func configureTextView() {
        phoneNumber.text = Model.cellArray[Index!].profPhoneNumber
        email.text = Model.cellArray[Index!].profEmail
        degreeText.text = Model.cellArray[Index!].profDegree
        roomNumber.text = Model.cellArray[Index!].staffRoom
        teachingText.text = Model.cellArray[Index!].teachingInterests
        currentResearchText.text = Model.cellArray[Index!].currentResearch
        publicationsText.text = Model.cellArray[Index!].publications
    }
    // This method makes the text view point to the starting of the text 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        degreeText.setContentOffset(CGPointZero, animated: false)
        currentResearchText.setContentOffset(CGPointZero, animated: false)
        teachingText.setContentOffset(CGPointZero, animated: false)
        publicationsText.setContentOffset(CGPointZero, animated: false)
    }

    
}
