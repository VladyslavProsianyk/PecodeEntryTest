//
//  NewsTableViewCellViewModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import Foundation

protocol NewsTableViewCellViewModelProtocol {
    func saveNewsToLiked(_ news: NewsResponseModel)
    func deleteExactNewsFromLiked(newsUrl: String)
}

class NewsTableViewCellViewModel: NewsTableViewCellViewModelProtocol {
    
    func saveNewsToLiked(_ news: NewsResponseModel) {
        DataSaver.shared.saveLikedNews(news.toRealmObject())
        NotificationCenter.default.post(name: .likedDidTap, object: nil)
    }
    
    func deleteExactNewsFromLiked(newsUrl: String) {
        DataSaver.shared.removeExactLikedNews(newsUrl)
        NotificationCenter.default.post(name: .likedDidTap, object: nil)
    }
}
