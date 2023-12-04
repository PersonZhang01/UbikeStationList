//
//  MenuTableViewCell.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/12/1.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.backgroundColor = selected ? .cellGray : .cellGray
    }
    
    func bind(to cellData: MenuModel?) {
        messageLabel.text = cellData?.name
        if let marked = cellData?.marked {
            messageLabel.textColor = marked ? .cellGreen : .black
        }
    }
    
}

