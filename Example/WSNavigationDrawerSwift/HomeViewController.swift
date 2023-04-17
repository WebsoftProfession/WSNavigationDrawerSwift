//
//  ViewController.swift
//  WSNavigationDrawer
//
//  Created by praveen on 13/04/23.
//

import UIKit
import WSNavigationDrawerSwift

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.drawer.isPanEnabled = true
        self.drawer.drawerMode = .all
//        self.drawer.drawerShadowColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func menuAction(_ sender: Any) {
        self.drawer.toggleDrawer(mode: .left)
    }
    
    @IBAction func sortAction(_ sender: Any) {
        self.drawer.toggleDrawer(mode: .right)
    }
    
}

