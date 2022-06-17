//
//  SourceTableViewCell.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import UIKit

class SourceTableViewCell: BaseTableViewCell {

    @IBOutlet weak var sourceCheckboxImageView: UIImageView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var sourceIsSelected = false {
        didSet {
            sourceCheckboxImageView.image = UIImage(named: sourceIsSelected ? "checked" : "unchecked")
            backView.layer.borderColor = sourceIsSelected ? 0x4D9FFF.hexColor.cgColor : UIColor.clear.cgColor
        }
    }
    
    var source: SourceElement!
    
    func configure(with source: SourceElement) {
        self.source = source
        sourceNameLabel.text = source.name
        backView.layer.borderWidth = 2
        backView.layer.cornerRadius = 10
        backView.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
