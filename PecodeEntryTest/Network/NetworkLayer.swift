//
//  NetworkLayer.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import Foundation
import RxSwift

class NetworkLayer {
    private init() {}
    
    static let shared = NetworkLayer()
        
    let newsObservableObject = PublishSubject<NewsApiResponse>()
    let sourcesObservableObject = PublishSubject<SourceResponseModel>()
    
    func getNewsWith(urlType: UrlTypes, pageNumber: Int, searchingFilters: SearchingFilters? = nil, searchingText: String? = nil, isNeedToBeSorted: Bool = false) {
                
        if let url = URL(string: urlType.createFullEndpointWith(pageNumber: pageNumber, searchingFilters: searchingFilters, searchingText: searchingText, isNeedToBeSort: isNeedToBeSorted)) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                
                if let error = error {
                    globalErrorSubject.onNext(error)
                    return
                }
                
                guard
                    let data = data,
                    let returnObject = try? JSONDecoder().decode(NewsApiResponse.self, from: data)
                else {
                    self?.newsObservableObject.onNext(NewsApiResponse(status: "", totalResults: 0, articles: []))
                    return
                }
                
                self?.newsObservableObject.onNext(returnObject)

            }.resume()
        }
    }
    
    func getSources() -> Observable<SourceResponseModel> {
        
        if let url = URL(string: UrlTypes.sources.url + apiKey) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                
                if let error = error {
                    globalErrorSubject.onNext(error)
                    return
                }
                
                guard
                    let data = data,
                    let returnObject = try? JSONDecoder().decode(SourceResponseModel.self, from: data)
                else { return }
                
                self?.sourcesObservableObject.onNext(returnObject)

            }.resume()
        }
        
        return sourcesObservableObject.asObservable()
    }
}

