//
//  NewsModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import Foundation
import RealmSwift

protocol NewsModelProtocol: AnyObject {
    var author: String? { get set }
    var title: String? { get set }
    var url: String? { get set }
    var urlToImage: String? { get set }
    var publishedAt: String? { get set }
    var content: String? { get set }
}

class NewsResponseModel: Codable, NewsModelProtocol {
    var source: SourceModel
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    init(source: SourceModel, author: String?, title: String?, description: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
    func toRealmObject() -> NewsRealmModel {
        let sourceObject = SourceRealmModel()
        sourceObject.id = source.id ?? ""
        sourceObject.name = source.name ?? ""
        
        let newsObject = NewsRealmModel()
        newsObject.source = sourceObject
        newsObject.author = author ?? ""
        newsObject.title = title ?? ""
        newsObject.desc = description ?? ""
        newsObject.url = url ?? ""
        newsObject.urlToImage = urlToImage ?? ""
        newsObject.publishedAt = publishedAt ?? ""
        newsObject.content = content ?? ""
        
        return newsObject
    }
}

class NewsRealmModel: Object, ObjectKeyIdentifiable, NewsModelProtocol {
//    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var source: SourceRealmModel? = SourceRealmModel()
    @Persisted var author: String? = ""
    @Persisted var title: String? = ""
    @Persisted var desc: String? = ""
    @Persisted(primaryKey: true) var url: String? = ""
    @Persisted var urlToImage: String? = ""
    @Persisted var publishedAt: String? = ""
    @Persisted var content: String? = ""
    
}
