//
//  SearchCustomCell.swift
//  
//  Created by Ramakrishna Sayee on 4/19/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
import UIKit

class SearchCustomCell: UITableViewCell{
    
    @IBOutlet var Name: UILabel!
    @IBOutlet var Department: UILabel!
    
    @IBOutlet weak var designation: UILabel!
    @IBOutlet var picture: UIImageView!
    
    // function to change the image to rounded rectangle
  func updateImage() -> (Void){
    
        picture.layer.cornerRadius = 10
        picture.clipsToBounds = true
    
    }
  
    
    }
