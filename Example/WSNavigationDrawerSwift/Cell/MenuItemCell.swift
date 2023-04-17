//
//  MenuItemCell.swift
//  WSNavigationDrawer
//
//  Created by praveen on 14/04/23.
//

import UIKit

class MenuItemCell: UITableViewCell {

    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
