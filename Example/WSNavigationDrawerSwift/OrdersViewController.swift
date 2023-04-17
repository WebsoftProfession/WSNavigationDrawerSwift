//
//  OrdersViewController.swift
//  WSNavigationDrawer
//
//  Created by praveen on 14/04/23.
//

import UIKit
import WSNavigationDrawerSwift

class OrdersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.drawer.drawerMode = .left
//        self.drawer.drawerShadowColor = .green
    }
    
    @IBAction func menuAction(_ sender: Any) {
        self.drawer.toggleDrawer(mode: .left)
    }
    
    @IBAction func orderDetailsAction(_ sender: Any) {
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC"))!, animated: true)
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
