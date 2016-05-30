//
//  NavigationController.swift
//  Conferencia
//
//  Created by Alexis Chan on 31/03/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit


class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        - #f6b540 (jaune)
        //        - #fab12f (jaune un peu plus foncé)
        //        - #86BBD8 (bleu)
        
        
        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.barTintColor = UIColor(hex : "#86BBD8")
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
}