//
//  NewsResponseModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import Foundation


struct NewsApiResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsResponseModel]
}
