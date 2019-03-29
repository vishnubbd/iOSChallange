//
//  ShowDetailTableViewCell.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/26/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit

class ShowDetailTableViewCell: UITableViewCell {
     @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showImageView.image = UIImage(named: GEN_STRINGS.DEFAULT_IMG)
    }
    
}
