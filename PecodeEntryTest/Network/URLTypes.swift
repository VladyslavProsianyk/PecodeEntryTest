//
//  URLTypes.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import Foundation

enum UrlTypes {
    
    case top_headlines
    case everything
    case sources
    
    private var host: String { "https://newsapi.org/v2/" }
    
    var url: String {
        
        var endpoint = host
        
        switch self {
        case .top_headlines:
            endpoint += "top-headlines?"
        case .everything:
            endpoint += "everything?"
        case .sources:
            endpoint += "top-headlines/" + "sources?"
        }
        
        return endpoint
    }
   
    func createFullEndpointWith(pageNumber: Int, searchingFilters: SearchingFilters) -> String {
        
        var host = url
        
        var country = ""
        var category = ""
        var sources = ""
        let page = "page=\(pageNumber)&"
        
        if searchingFilters.country != .allCountries {
            country = "country=" + searchingFilters.country.rawValue + "&"
        }
        
        if searchingFilters.category != .allCategories {
            category = "category=" + searchingFilters.category.rawValue + "&"
        }
        
        if searchingFilters.sources.count != 0 {
            sources = "sources="
            searchingFilters.sources.forEach({ sources += $0.id + "," })
            sources.removeLast()
        }
        
        if country + category + sources == "" {
            host += "country=ua&"
        }
        
        return host + country + category + sources + page + apiKey
    }
}
