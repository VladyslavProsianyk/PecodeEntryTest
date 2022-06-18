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
   
    func createFullEndpointWith(pageNumber: Int, searchingFilters: SearchingFilters?, searchingText: String? = nil, isNeedToBeSort: Bool) -> String {
        
        var host = url
        let page = "page=\(pageNumber)&"
        
        if searchingText != nil && self == .everything {
            let searchingText = searchingText?.replacingOccurrences(of: " ", with: "+") ?? "Ukraine"
            return host + "q=" + searchingText + "&" + page + apiKey
        }
        
        guard let searchingFilters = searchingFilters else { return "" }
        
        var country = ""
        var category = ""
        var sources = ""
        var sortBy = ""
        
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
        
        if searchingFilters.isNeedToBeSorted {
            sortBy += "sortBy=publishedAt&"
        }
        
        if country + category + sources == "" {
            host += "country=ua&"
        }
        
        return host + country + category + sortBy + sources + page + apiKey
    }
    
}
