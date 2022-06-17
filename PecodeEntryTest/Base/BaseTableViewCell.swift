//
//  BaseTableViewCell.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import UIKit

protocol BaseTableViewCellProtocol {
    static func uiNib() -> UINib
    static var identifire: String { get }
}

class BaseTableViewCell: UITableViewCell, BaseTableViewCellProtocol {
    static func uiNib() -> UINib {
        return UINib(nibName: self.identifire, bundle: nil)
    }
    
    static var identifire: String {
        return String(describing: self)
    }
    
}
