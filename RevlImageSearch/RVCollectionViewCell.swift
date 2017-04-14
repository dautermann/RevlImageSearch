//
//  RVCollectionViewCell.swift
//  RevlImageSearch
//
//  Created by Michael Dautermann on 4/10/17.
//  Copyright © 2017 Michael Dautermann. All rights reserved.
//

import UIKit
import SDWebImage

class RVCollectionViewCell: UICollectionViewCell
{
    var imageObject : ImageObject?
    {
        didSet
        {
            imageView.sd_setImage(with: imageObject?.thumbnailURL)
        }
    }

    @IBOutlet weak var imageView : UIImageView!
    
    override func prepareForReuse()
    {
        imageObject = nil
    }

}
