//
//  DropDownMenuView.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/12/1.
//

import UIKit

protocol DropDownMenuViewDelegate: AnyObject {
    func selectButtonPressed(withTag tag: Int)
    /*
     一個畫面有用到多個DropDownMenuView時要設定tag
     */
}

class DropDownMenuView: UIView {
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tapButton: UIButton!
    
    weak var delegate: DropDownMenuViewDelegate?
    
    public enum MenuUIState {
        case empty, single, many
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }
    
    private func loadXib() {
        let nib = DropDownMenuView.nib
        let xibView = nib.instantiate(withOwner: self)[0] as! UIView
        addSubview(xibView)
        
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.setView(withCornerRadius: CornerRadiusSize.small,
                     borderColor: .lightGray,
                     borderWidth: BorderWidthSize.thin)
    }
    
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.selectButtonPressed(withTag: self.tag)
    }
    
    func updateMenuUI(withListCount listCount: Int, selection: String?,marked: Bool = false, placeHolder: String = " ") {
        var status: MenuUIState = .empty
        switch listCount {
        case 0: status = .empty
        case 1: status = .single
        default: status = .many
        }
        
        let selectText = (selection == nil) ? placeHolder : selection
        var changeImage: UIImage?
        switch status {
        case .empty: break
        case .single: break
        case .many:
            changeImage = UIImage(named: ImageName.search)
        }
        titleLabel.textColor = marked ? .red : .black
        iconImage.image = changeImage
        titleLabel.text = selectText
        tapButton.isEnabled = (status == .many)
        
        if selectText == placeHolder {
            titleLabel.textColor = .lightGray
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

