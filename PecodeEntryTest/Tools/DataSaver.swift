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
    
    private init() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            
            Realm.Configuration.defaultConfiguration = config
            
            realm = try Realm()
        } catch {
            globalErrorSubject.onNext(error)
        }
    }
    
    static let shared = DataSaver()
    
    private let userDefaults = UserDefaults()
    
    var realm: Realm?
        
    func saveLikedNews(_ news: NewsRealmModel) {
        guard let realm = realm else { return }

        realm.beginWrite()
        realm.add(news, update: .modified)
        do {
            try realm.commitWrite()
        } catch {
            globalErrorSubject.onNext(error)
        }
    }

    func getAllLikedNews() -> [NewsRealmModel] {
        guard let realm = realm else { return [] }
        
        var savedNews: [NewsRealmModel] = []
        realm.objects(NewsRealmModel.self).forEach { savedNews.append($0) }
        return savedNews
    }
    
    func removeAllLikedNews() {
        guard let realm = realm else { return }
        
        realm.beginWrite()
        realm.delete(realm.objects(NewsRealmModel.self))
        do {
            try realm.commitWrite()
        } catch {
            globalErrorSubject.onNext(error)
        }
    }
    
    func removeExactLikedNews(_ newsUrl: String) {
        guard let realm = realm else { return }
        
        do {
            try realm.write({
                
                let itemToDelete = realm.objects(NewsRealmModel.self).filter { item in
                    return item.url == newsUrl
                }
                
                realm.delete(itemToDelete)
            })
        } catch {
            globalErrorSubject.onNext(error)
        }
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
            return SearchingFilters(country: .allCountries, category: .allCategories, sources: [], isNeedToBeSorted: false)
        }
        return decodedObject
    }
}
