//
//  HomeViewModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import RxSwift
import Darwin
import Foundation

class HomeViewModel {
    
    var router: RouterProtocol?
    
    let news = BehaviorSubject<[NewsModel]>(value: [])
    
    var newsPageNumber = 0
    var totalResults = 0
    
    var isLoading = false
    
    func getNews(loadFromStart: Bool, disposeBag: DisposeBag) {
        if (newsPageNumber) * 20 > totalResults && totalResults != 0 {
            return
        }
        
        isLoading = true
        newsPageNumber += 1
        
        if loadFromStart {
            newsPageNumber = 1
        }
        
        NetworkLayer.shared.getNewsWith(pageNumber: newsPageNumber, searchingFilters: getSerchingFilters()).subscribe(onNext: { [weak self] response in            
            var news = [NewsModel]()
            
            if let oldNews = try? self?.news.value(), !loadFromStart {
                news.append(contentsOf: oldNews)
            }
            news.append(contentsOf: response.articles)
            self?.totalResults = response.totalResults
            self?.news.onNext(news)
            self?.isLoading = false
        }).disposed(by: disposeBag)
        
    }
    
    func openWebPage(urlString: String, title: String) {
        guard let url = URL(string: urlString) else { return }
        router?.openWeb(url: url, title: title)
    }
    
    func openSearhSettings() {
        router?.presentSearchSettings()
    }
    
    func getSerchingFilters() -> SearchingFilters {
        DataSaver.shared.getSearchingFilters()
    }
}
