//
//  ImageCollectionViewCell.swift
//  WeboniseAssignment
//
//  Created by Amit Pant on 24/06/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import UIKit

//protocol for download image method
protocol ImageCollectionViewCellDelegate:NSObjectProtocol {
    func downloadImage(photoIndex: Int)
}

class ImageCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate:ImageCollectionViewCellDelegate!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    
    //MARK: - Action
    @IBAction func downloadBtnPressed(_ sender: UIButton) {
        
        self.delegate.downloadImage(photoIndex: sender.tag)
    }
    
}
