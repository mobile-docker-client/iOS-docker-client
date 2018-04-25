//
//  SettingsServerTableViewCell.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 25.04.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import UIKit

class SettingsServerTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var url: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func setup(with: Server) {
        name.text = with.name ?? "No name"
        url.text = with.url ?? ""
    }
    
}
