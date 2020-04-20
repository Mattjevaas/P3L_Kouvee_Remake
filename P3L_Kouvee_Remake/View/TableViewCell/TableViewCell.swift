//
//  TableViewCell.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 20/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var txtOne: UILabel!
    @IBOutlet weak var txtTwo: UILabel!
    @IBOutlet weak var txtThree: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        bubbleView.layer.cornerRadius = bubbleView.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
