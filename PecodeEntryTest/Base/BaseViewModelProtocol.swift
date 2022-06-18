//
//  BaseViewModelProtocol.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 18.06.2022.
//

import Foundation

protocol BaseViewModelProtocol: AnyObject {
    var router: RouterProtocol? { get set }
}
