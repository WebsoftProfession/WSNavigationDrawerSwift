//
//  OrderDetailsViewController.swift
//  WSNavigationDrawer
//
//  Created by praveen on 14/04/23.
//

import UIKit
import WSNavigationDrawerSwift

class OrderDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawer.isPanEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.drawer.isPanEnabled = true
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
