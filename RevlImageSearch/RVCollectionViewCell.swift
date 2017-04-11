//
//  RVCollectionViewCell.swift
//  RevlImageSearch
//
//  Created by Michael Dautermann on 4/10/17.
//  Copyright © 2017 Michael Dautermann. All rights reserved.
//

import UIKit
import SDWebImage

class RVCollectionViewCell: UICollectionViewCell {
    
    var imageObject : ImageObject?
    @IBOutlet weak var imageView : UIImageView!
    
    override func prepareForReuse() {
        imageObject = nil
    }
    
    // I could have put this in as a property setter, but 
    // just in case the cell hasn't been instantiated / loaded 
    // into memory yet, we'll do it explicitly here (which happens
    // after the cell has been dequeued and is ready to go)
    func setImageObject(_ imageObjectToSet : ImageObject)
    {
        imageObject = imageObjectToSet
        
        imageView.sd_setImage(with: imageObject?.thumbnailURL)
    }
    
}
