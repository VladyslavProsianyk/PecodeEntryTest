//
//  HomeViewController.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController<HomeViewModel>, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    lazy var likedNewsBarButtonItem: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: nil, action: nil)
        v.tintColor = .red
        return v
    }()
    
    lazy var searchSettingsBarButtonItem: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: nil, action: nil)
        v.tintColor = .black
        return v
    }()
    
    override func performPreSetup() {
        title = "Home"
        
        setupViews()
        setBinders()
        
        viewModel
            .getNews(loadFromStart: true, disposeBag: defaultDisposeBag)
    }
    
    private func setupViews() {
        newsTableView
            .register(NewsTableViewCell.uiNib(), forCellReuseIdentifier: NewsTableViewCell.identifire)
        
        newsTableView
            .rx
            .setDelegate(self)
            .disposed(by: defaultDisposeBag)
        
        navigationItem.rightBarButtonItem = likedNewsBarButtonItem
        navigationItem.leftBarButtonItem = searchSettingsBarButtonItem
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.getNews(loadFromStart: true, disposeBag: defaultDisposeBag)
    }
    
    private func setBinders() {
        viewModel
            .news
            .do(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.newsTableView.tableFooterView = nil
                }
            })
            .bind(to: newsTableView
                .rx
                .items(cellIdentifier: NewsTableViewCell.identifire, cellType: NewsTableViewCell.self)) { [weak self] row, item, cell in
                    cell.configure(with: item)
                    if self?.refreshControl.isRefreshing == true {
                        self?.refreshControl.endRefreshing()
                    }
                }.disposed(by: defaultDisposeBag)
        
        newsTableView
            .rx
            .modelSelected(NewsModel.self)
            .subscribe(onNext: { [weak self] item in
                self?.viewModel.openWebPage(urlString: item.url ?? "", title: item.source.name ?? "")
            }).disposed(by: defaultDisposeBag)
        
        likedNewsBarButtonItem
            .performWhemTap {
                print("liked is tapped")
            }.disposed(by: defaultDisposeBag)
        
        searchSettingsBarButtonItem
            .performWhemTap { [weak self] in
                self?.viewModel.openSearhSettings()
            }.disposed(by: defaultDisposeBag)
        
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
        
        let spinner = UIActivityIndicatorView()
        footerView.addSubview(spinner)
        spinner.center = footerView.center
        spinner.startAnimating()
        
        return footerView
    }
    
}

extension HomeViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (newsTableView.contentSize.height - 300 - scrollView.frame.size.height) && !viewModel.isLoading {
            newsTableView.tableFooterView = createSpinnerFooter()
            
            viewModel.getNews(loadFromStart: false, disposeBag: defaultDisposeBag)
            
        }
    }
    
}
