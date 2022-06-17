//
//  SourceModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import Foundation
import RealmSwift

struct SourceModel: Codable {
    let id: String?
    let name: String?
}

class SourceModelRealmObject: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    
    init(id: String?, name: String?) {
        self.name = name
        self.id = id
    }
}
