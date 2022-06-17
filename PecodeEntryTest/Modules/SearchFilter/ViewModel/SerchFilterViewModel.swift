//
//  SerchFilterViewModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import Foundation
import RxSwift
import RxCocoa

class SerchFilterViewModel {
    
    var router: RouterProtocol?
    
    func getSources(disposeBag: DisposeBag) -> Observable<[SourceElement]> {
        let sourcesPublishSubject = PublishSubject<[SourceElement]>()
        
        NetworkLayer.shared.getSources().subscribe(onNext: { response in
            sourcesPublishSubject.onNext(response.sources)
        }).disposed(by: disposeBag)
        
        return sourcesPublishSubject.asObservable()
    }
    
    func dismiss() {
        router?.dismissVC()
    }
    
    func saveSearchingSettings(country: SupportedCountries, category: Categories, sources: [SourceElement]) {
        let settings = SearchingFilters(country: country, category: category, sources: sources)
        DataSaver.shared.saveSearchingFilters(settings)
    }
    
    func getSearchingSettings() -> SearchingFilters {
        DataSaver.shared.getSearchingFilters()
    }
}
