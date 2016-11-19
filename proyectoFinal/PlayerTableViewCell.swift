//
//  PlayerTableViewCell.swift
//  proyectoFinal
//
//  Created by Eliezer Hernandez on 18/11/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet var PlayerName: UILabel!
    
    @IBOutlet var LugarLabel: UILabel!

    @IBOutlet var SaludosLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
