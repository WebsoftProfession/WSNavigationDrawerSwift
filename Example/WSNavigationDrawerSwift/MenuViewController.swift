//
//  MenuViewController.swift
//  WSNavigationDrawer
//
//  Created by praveen on 13/04/23.
//

import UIKit
import WSNavigationDrawerSwift

class MenuViewController: UIViewController {

    var menus:[[String:String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        menus.append(["image":"house.circle.fill", "title":"Home"])
        menus.append(["image":"list.bullet.circle.fill", "title":"Orders"])
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        cell.imgView.image = UIImage.init(systemName: menus[indexPath.row]["image"]!)
        cell.lblTitle.text = menus[indexPath.row]["title"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let navVC = self.drawer.homeViewController as! UINavigationController
        
        if indexPath.row == 0 {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
            navVC.setViewControllers([homeVC!], animated: true)
        }
        else{
            let ordersVC = self.storyboard?.instantiateViewController(withIdentifier: "OrdersVC")
            navVC.setViewControllers([ordersVC!], animated: true)
        }
        self.drawer.toggleDrawer(mode: .left)
    }
}
