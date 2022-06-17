//
//  SourceResponseModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import Foundation

struct SourceResponseModel: Codable {
    let status: String
    let sources: [SourceElement]
}

struct SourceElement: Codable {
    let id: String
    let name: String
    let description: String
    let url: String
    let category: String
    let language: String
    let country: String
}
