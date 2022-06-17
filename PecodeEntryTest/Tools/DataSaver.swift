//
//  DataSaver.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import Foundation
import Realm
import RealmSwift

class DataSaver {
    
    private init() {}
    static let shared = DataSaver()
    
    private let userDefaults = UserDefaults()
    
    func saveObject<U: Object>(_ object: U) {
        let realm = try! Realm()
        realm.add(object)
    }
    
    func printObjectsInRealm<U: Object>(_ object: U) {
        let realm = try! Realm()
        
        print(realm.objects(U.self).description)
    }
    
    func saveSearchingFilters(_ filters: SearchingFilters) {
        guard let encodedData = try? JSONEncoder().encode(filters) else { return }
        
        userDefaults.set(encodedData, forKey: "SearchingFilters")
    }
    
    func getSearchingFilters() -> SearchingFilters {
        guard
            let data = userDefaults.data(forKey: "SearchingFilters"),
            let decodedObject = try? JSONDecoder().decode(SearchingFilters.self, from: data)
        else {
            return SearchingFilters(country: .allCountries, category: .allCategories, sources: [])
        }
        return decodedObject
    }
}
