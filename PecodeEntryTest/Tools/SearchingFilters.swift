//
//  SearchingFilters.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import Foundation

struct SearchingFilters: Codable {
    var country: SupportedCountries
    var category: Categories
    var sources: [SourceElement]
    var isNeedToBeSorted: Bool
}

enum SupportedCountries: String, CaseIterable, Codable {
    
    case allCountries
    
    case ae, ar, at, au, be, bg, br, ca, ch, cn, co, cu, cz, de
    case eg, fr, gb, gr, hk, hu, id, ie, il, it, jp, kr, lt
    case lv, ma, mx, my, ng, nl, no, nz, ph, pl, pt, ro, rs
    case ru, sa, se, sg, si, sk, th, tr, tw, ua, us, ve, za
    
    var countryName: String {
        if self == .allCountries {
            return "All countries"
        }
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: rawValue) {
            return name
        } else {
            return rawValue
        }
    }
    
    var endpoint: String {
        if self == .allCountries {
            return ""
        } else {
            return "country=" + rawValue.lowercased() + "&"
        }
    }
}

enum Categories: String, CaseIterable, Codable {
    case allCategories
    
    case Business
    case Entertainment
    case General
    case Health
    case Science
    case Sports
    case Technology
    
    var title: String {
        if self == .allCategories {
            return "All categories"
        } else {
            return rawValue
        }
    }
    
    var endpoint: String {
        if self == .allCategories {
            return ""
        } else {
            return "category=" + rawValue.lowercased() + "&"
        }
    }
    
}
