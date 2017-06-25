//
//  PlaceTableViewCell.swift
//  WeboniseAssignment
//
//  Created by Amit Pant on 24/06/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var searchPlaceTypeLabel: UILabel!
    @IBOutlet weak var searchPlaceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
