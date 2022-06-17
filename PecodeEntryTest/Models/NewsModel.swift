//
//  NewsModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import Foundation
import RealmSwift

class NewsModel: Codable {
    let source: SourceModel
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
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
    
    func getRealmObject() -> Object {
        return NewsModelRealmObject(source: SourceModelRealmObject(id: source.id,
                                                                              name: source.name),
                                               author: author,
                                               title: title,
                                               description: description,
                                               url: url,
                                               urlToImage: urlToImage,
                                               publishedAt: publishedAt,
                                               content: content)
    }
}

class NewsModelRealmObject: Object {
    
    @objc dynamic var source: SourceModelRealmObject
    @objc dynamic var author: String?
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var url: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var publishedAt: String?
    @objc dynamic var content: String?
    
    init(source: SourceModelRealmObject, author: String?, title: String?, description: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.desc = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
}
