//
//  SerchFilterViewModel.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol SerchFilterViewModelProtocol: BaseViewModelProtocol {
    func getSources(disposeBag: DisposeBag) -> Observable<[SourceElement]>
    func dismiss(dismissAction: (()->Void)?)
    func saveSearchingSettings(country: SupportedCountries, category: Categories, sources: [SourceElement], isNeedToBeSorted: Bool)
    func getSearchingSettings() -> SearchingFilters
}

class SerchFilterViewModel: SerchFilterViewModelProtocol {
    
    var router: RouterProtocol?
    
    func getSources(disposeBag: DisposeBag) -> Observable<[SourceElement]> {
        let sourcesPublishSubject = PublishSubject<[SourceElement]>()
        
        NetworkLayer.shared.getSources().subscribe(onNext: { response in
            sourcesPublishSubject.onNext(response.sources)
        }).disposed(by: disposeBag)
        
        return sourcesPublishSubject.asObservable()
    }
    
    func dismiss(dismissAction: (()->Void)?) {
        router?.dismissVC(dismissAction: dismissAction)
    }
    
    func saveSearchingSettings(country: SupportedCountries, category: Categories, sources: [SourceElement], isNeedToBeSorted: Bool) {
        let settings = SearchingFilters(country: country, category: category, sources: sources, isNeedToBeSorted: isNeedToBeSorted)
        DataSaver.shared.saveSearchingFilters(settings)
    }
    
    func getSearchingSettings() -> SearchingFilters {
        DataSaver.shared.getSearchingFilters()
    }
}
