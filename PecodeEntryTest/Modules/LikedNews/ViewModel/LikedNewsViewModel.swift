//
//  LikedNewsViewModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 18.06.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol LikedNewsViewModelProtocol: BaseViewModelProtocol {
    var likedNews: PublishSubject<[NewsRealmModel]> { get }
    func deleteAllLikedNews()
    func getLikedNews()
    func openWebPage(urlString: String, title: String)
}

class LikedNewsViewModel: LikedNewsViewModelProtocol {
    
    var likedNews = PublishSubject<[NewsRealmModel]>()
    
    var router: RouterProtocol?
    
    func deleteEactNews(_ newsUrl: String) {
        DataSaver.shared.removeExactLikedNews(newsUrl)
        getLikedNews()
    }
    
    func deleteAllLikedNews() {
        DataSaver.shared.removeAllLikedNews()
        getLikedNews()
    }
    
    func getLikedNews() {
        likedNews.onNext(DataSaver.shared.getAllLikedNews())
    }
    
    func openWebPage(urlString: String, title: String) {
        guard let url = URL(string: urlString) else { return }
        router?.openWeb(url: url, title: title)
    }
    
}
