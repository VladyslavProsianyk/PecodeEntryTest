//
//  SerchFilterViewController.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import UIKit
import RxCocoa
import RxSwift

class SerchFilterViewController: BaseViewController<SerchFilterViewModel>, UITableViewDelegate {
    
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var sourcesTableView: UITableView!
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        viewModel.dismiss()
    }
    
    @IBAction func doneButtonDidTap(_ sender: UIButton) {
        viewModel.saveSearchingSettings(country: selectedCountry, category: selectedCategory, sources: selectedSources)
    }
    
    override func performPreSetup() {
        presetup()
        setupTableView()
        setupPickers()
        setBinders()
    }
    
    private var selectedSources: [SourceElement] = []
    private var sourcesList: [SourceElement] = []
    
    private var selectedCountry: SupportedCountries = .allCountries
    private var selectedCategory: Categories = .allCategories
    
    private var allCountriesAndCategoriesIsSelected: Bool {
        return selectedCountry == .allCountries && selectedCategory == .allCategories
    }
    
    private func presetup() {
        let settings = viewModel.getSearchingSettings()
        
        selectedSources = settings.sources
        selectedCountry = settings.country
        selectedCategory = settings.category
        
    }
    
    private func setupTableView() {
        
        sourcesTableView
            .register(SourceTableViewCell.uiNib(), forCellReuseIdentifier: SourceTableViewCell.identifire)
        
        sourcesTableView
            .rx
            .setDelegate(self)
            .disposed(by: defaultDisposeBag)
        
        sourcesTableView.separatorColor = .clear
    }
    
    private func setupPickers() {
       Observable
            .just(SupportedCountries.allCases.map({ return $0.countryName }))
            .bind(to: countryPickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: defaultDisposeBag)
        
        Observable
             .just(Categories.allCases.map({ return $0.title }))
             .bind(to: categoryPickerView.rx.itemTitles) { (row, element) in
                 return element
             }
             .disposed(by: defaultDisposeBag)
        
        countryPickerView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] itemIndex in
                if self?.selectedSources.count != 0 {
                    self?.showToast("Sorry, but you can't mix this param with the \"Sources\" params")
                    self?.countryPickerView.selectRow(0, inComponent: 0, animated: true)
                } else {
                    self?.selectedCountry = SupportedCountries.allCases[itemIndex.row]
                }
            }).disposed(by: defaultDisposeBag)
        
        categoryPickerView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] itemIndex in
                if self?.selectedSources.count != 0 {
                    self?.showToast("Sorry, but you can't mix this param with the \"Sources\" params")
                    self?.categoryPickerView.selectRow(0, inComponent: 0, animated: true)
                } else {
                    self?.selectedCategory = Categories.allCases[itemIndex.row]
                }
            }).disposed(by: defaultDisposeBag)
        
        countryPickerView.selectRow(SupportedCountries.allCases.firstIndex(of: selectedCountry) ?? 0, inComponent: 0, animated: true)
        categoryPickerView.selectRow(Categories.allCases.firstIndex(of: selectedCategory) ?? 0, inComponent: 0, animated: true)
        
    }

    private func setBinders() {
        
        viewModel
            .getSources(disposeBag: defaultDisposeBag)
            .do(onNext: { self.sourcesList.append(contentsOf: $0) })
            .bind(to: sourcesTableView
                .rx
                .items(cellIdentifier: SourceTableViewCell.identifire, cellType: SourceTableViewCell.self)) { [weak self] row, item, cell in
                    cell.configure(with: item)
                    cell.sourceIsSelected = self?.selectedSources.contains(where: { $0.name == item.name }) ?? false
                }.disposed(by: defaultDisposeBag)
        
        sourcesTableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if self?.allCountriesAndCategoriesIsSelected == false {
                    self?.showToast("Sorry, but you can't mix this param with the \"Country\" or \"Category\" params")
                    return
                }
                guard let cell = self?.sourcesTableView.cellForRow(at: indexPath) as? SourceTableViewCell else { return }
                cell.sourceIsSelected = !cell.sourceIsSelected
                if cell.sourceIsSelected {
                    self?.selectedSources.append(cell.source)
                } else {
                    guard let index = self?.selectedSources.firstIndex(where: { $0.name == (self?.sourcesList[indexPath.row].name)}) else { return }
                    self?.selectedSources.remove(at: index)
                }
            }).disposed(by: defaultDisposeBag)
    }
}
