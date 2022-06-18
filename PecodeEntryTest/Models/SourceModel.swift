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

class SourceRealmModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var sourceId: String
    
    @Persisted var id: String = ""
    @Persisted var name: String = ""
}
