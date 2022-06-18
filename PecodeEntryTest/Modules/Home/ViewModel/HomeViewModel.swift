//
//  HomeViewModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import RxSwift
import RxCocoa
import Darwin
import Foundation

protocol HomeViewModelProtocol: BaseViewModelProtocol {
    var news: PublishRelay<[NewsResponseModel]> { get }
    func getNews(loadFromStart: Bool, disposeBag: DisposeBag, searchingText: String?)
    func getSerchingFilters() -> SearchingFilters
    func getLikedNews() -> [NewsRealmModel]
    func openWebPage(urlString: String, title: String)
    func openSearhSettings(dismissAction: @escaping (()->Void))
    func openLikedNewsPage()
}

class HomeViewModel: HomeViewModelProtocol {
    
    var router: RouterProtocol?
    
    var news = PublishRelay<[NewsResponseModel]>()
    
    var oldNews: [NewsResponseModel] = []
    
    var noInternetHandler: (()->Void)?
    
    var isLoading = false
    
    private var newsPageNumber = 0
    var totalResults = 0
    
    var disposeBag: DisposeBag? = DisposeBag()
    
    init() {
        NetworkLayer
            .shared
            .newsObservableObject
            .subscribe(onNext: { [weak self] response in
                self?.totalResults = response.totalResults
                if self?.newsPageNumber == 1 {
                    self?.oldNews = []
                    self?.news.accept(response.articles)
                } else {
                    let oldData = self?.oldNews ?? []
                    if(response.articles.count > 0) {
                        self?.news.accept(oldData + response.articles)
                    }
                }
                self?.oldNews.append(contentsOf: response.articles)
                self?.isLoading = false
            }).disposed(by: disposeBag!)
    }
    
    deinit {
        disposeBag = nil
    }
    
    func getNews(loadFromStart: Bool, disposeBag: DisposeBag, searchingText: String?) {

        isLoading = true
        newsPageNumber += 1
        
        if loadFromStart {
            newsPageNumber = 1
        }
        
        NetworkLayer
            .shared
            .getNewsWith(urlType: searchingText == nil ? .top_headlines : .everything, pageNumber: newsPageNumber, searchingFilters: getSerchingFilters(), searchingText: searchingText)
            
    }
    
    func getLikedNews() -> [NewsRealmModel] {
        DataSaver.shared.getAllLikedNews()
    }
    
    func getSerchingFilters() -> SearchingFilters {
        DataSaver.shared.getSearchingFilters()
    }
    
    func openWebPage(urlString: String, title: String) {
        guard let url = URL(string: urlString) else { return }
        router?.openWeb(url: url, title: title)
    }
    
    func openSearhSettings(dismissAction: @escaping (()->Void)) {
        router?.presentSearchSettings(dismissAction: dismissAction)
    }
    
    func openLikedNewsPage() {
        router?.openLikedNewsPage()
    }
}
