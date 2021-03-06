//
//  RVImageDetailViewController.swift
//  RevlImageSearch
//
//  Created by Michael Dautermann on 4/10/17.
//  Copyright © 2017 Michael Dautermann. All rights reserved.
//

import UIKit
import SDWebImage

class RVImageDetailViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView!
    var imageObject : ImageObject?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        imageView.sd_setImage(with: imageObject?.contentURL)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
