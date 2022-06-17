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
        
    private let newsObservableObject = PublishSubject<NewsResponseModel>()
    private let sourcesObservableObject = PublishSubject<SourceResponseModel>()
    
    func getNewsWith(pageNumber: Int, searchingFilters: SearchingFilters) -> Observable<NewsResponseModel> {
                
        if let url = URL(string: UrlTypes.top_headlines.createFullEndpointWith(pageNumber: pageNumber, searchingFilters: searchingFilters)) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                
                if let error = error {
                    globalErrorSubject.onNext(error)
                    return
                }
                
                guard
                    let data = data,
                    let returnObject = try? JSONDecoder().decode(NewsResponseModel.self, from: data)
                else { return }
                
                self?.newsObservableObject.onNext(returnObject)

            }.resume()
        }
        
        return newsObservableObject.asObservable()
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

