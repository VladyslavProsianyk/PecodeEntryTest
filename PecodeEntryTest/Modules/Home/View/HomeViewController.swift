//
//  HomeViewController.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import UIKit
import RxSwift
import RxCocoa
import Network

class HomeViewController: BaseViewController<HomeViewModel>, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 40))
        label.text = "Nothing found"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    var searchTask: DispatchWorkItem?
    
    var hasInternetConnection: Bool = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refresh()
    }
        
    override func performPreSetup() {
        title = "Home"
        
        setupViews()
        setBinders()
        
    }
    
    private func setupViews() {
        newsTableView
            .register(NewsTableViewCell.uiNib(), forCellReuseIdentifier: NewsTableViewCell.identifire)
        
        newsTableView
            .rx
            .setDelegate(self)
            .disposed(by: defaultDisposeBag)
        
        newsTableView
            .addSubview(refreshControl)
        
        refreshControl
            .addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = likedNewsBarButtonItem
        navigationItem.leftBarButtonItem = searchSettingsBarButtonItem
        
        newsTableView.keyboardDismissMode = .onDrag
        
    }
    
    @objc private func refresh(fromStart: Bool = true) {
        if hasInternetConnection {
            viewModel.getNews(loadFromStart: true, disposeBag: defaultDisposeBag, searchingText: searchBar.text?.isEmpty == true ? nil : searchBar.text)
        } else {
            showToast("No internet connection")
        }
    }
    
    private func setBinders() {
        viewModel
            .news
            .do(onNext: { [weak self] news in
                DispatchQueue.main.async {
                    if news.isEmpty {
                        self?.view.addSubview(self?.emptyStateLabel ?? UIView())
                        self?.emptyStateLabel.center = self?.view.center ?? CGPoint(x: kScreenWidth/2, y: kScreenHeight/2)
                    } else {
                        self?.emptyStateLabel.removeFromSuperview()
                    }
                    self?.newsTableView.tableFooterView = nil
                }
            })
            .bind(to: newsTableView
                .rx
                .items(cellIdentifier: NewsTableViewCell.identifire, cellType: NewsTableViewCell.self)) { [weak self] row, item, cell in
                    let isLikedNews = self?.viewModel.getLikedNews().contains(where: { $0.url == item.url }) ?? false
                    cell.configure(with: item)
                    cell.viewModel = NewsTableViewCellViewModel()
                    cell.newsIsLiked = isLikedNews
                    self?.hideLoading()
                    if self?.refreshControl.isRefreshing == true {
                        self?.refreshControl.endRefreshing()
                    }
                }.disposed(by: defaultDisposeBag)
        
        newsTableView
            .rx
            .modelSelected(NewsResponseModel.self)
            .subscribe(onNext: { [weak self] item in
                self?.viewModel.openWebPage(urlString: item.url ?? "", title: item.source.name ?? "")
            }).disposed(by: defaultDisposeBag)
        
        likedNewsBarButtonItem
            .performWhemTap { [weak self] in
                self?.viewModel.openLikedNewsPage()
            }.disposed(by: defaultDisposeBag)
        
        searchSettingsBarButtonItem
            .performWhemTap { [weak self] in
                self?.viewModel.openSearhSettings(dismissAction: { [weak self] in
                    self?.showLoading()
                    self?.refresh()
                })
            }.disposed(by: defaultDisposeBag)
        
        searchBar
            .rx
            .text
            .changed
            .subscribe(onNext: { [weak self] _ in
                self?.sendRequestWithDelay()
            }).disposed(by: defaultDisposeBag)
        
        searchBar
            .rx
            .cancelButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.text?.removeAll()
                self?.searchBar.endEditing(true)
            }).disposed(by: defaultDisposeBag)
        
        searchBar
            .rx
            .searchButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.endEditing(true)
            }).disposed(by: defaultDisposeBag)
        
        
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.hasInternetConnection = path.status == .satisfied
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
        
        let spinner = UIActivityIndicatorView()
        footerView.addSubview(spinner)
        spinner.center = footerView.center
        spinner.startAnimating()
        
        return footerView
    }
    
    private func sendRequestWithDelay() {
        self.searchTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            self?.refresh()
        }
        
        self.searchTask = task
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
    
}

extension HomeViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        
        
        if position > (newsTableView.contentSize.height - 300 - scrollView.frame.size.height) && !viewModel.isLoading && viewModel.oldNews.count < viewModel.totalResults  {
                        
            refresh(fromStart: false)
            
            newsTableView.tableFooterView = createSpinnerFooter()
            
        }
    }
    
}
