//
//  FirstViewController.swift
//  proyectoFinal
//
//  Created by Vicente Reyes on 11/8/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet var Photo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.Photo.image = UIImage(named: "BJ")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

