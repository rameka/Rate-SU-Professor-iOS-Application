//
//  ReviewCell.swift
//  
//
//  Created by Ramakrishna Sayee on 4/22/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
import UIKit

class ReviewCell: UITableViewCell{
    
    @IBOutlet weak var cNameAndcNumber: UILabel!
    @IBOutlet weak var reviewTitle: UILabel!
    
    @IBOutlet weak var star1: UILabel!
    @IBOutlet weak var star2: UILabel!
    @IBOutlet weak var star3: UILabel!
    @IBOutlet weak var star4: UILabel!
    @IBOutlet weak var star5: UILabel!
    @IBOutlet weak var difficultValue: UILabel!
    @IBOutlet weak var comment: UITextView!
    

        // This display the stars in ratings and review page based on the rating value
    @IBAction func starDisplay(value:Int){
        if(value == 1){
            star5.hidden = !star5.hidden
            star4.hidden = !star4.hidden
            star3.hidden = !star3.hidden
            star2.hidden = !star2.hidden
        }
        else if(value == 2){
            star5.hidden = !star5.hidden
            star4.hidden = !star4.hidden
            star3.hidden = !star3.hidden
        }
        else if(value == 3){
            star5.hidden = !star5.hidden
            star4.hidden = !star4.hidden
        }
        else if(value == 4){
            star5.hidden = !star5.hidden
           
        }
        else{
            
        }
    }
    
}