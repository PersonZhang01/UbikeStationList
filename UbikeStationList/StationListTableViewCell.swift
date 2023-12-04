//
//  StationListTableViewCell.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/11/30.
//

import UIKit


class StationListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var selectIndexPath: IndexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureUI() {
        
    }
    
    func bindWithList(cellData: StationListItem, indexPath: IndexPath) {
        selectIndexPath = indexPath
        cityLabel.text = Constant.taipei
        areaLabel.text = cellData.sarea ?? " "
        nameLabel.text = cellData.sna?.replacingOccurrences(of: "_", with: "\n") ?? " "
        
        self.contentView.backgroundColor = (indexPath.row % 2 == 1) ? .cellGray : .white
        
    }
    
}

