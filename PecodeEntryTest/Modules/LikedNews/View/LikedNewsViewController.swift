//
//  LikedNewsViewController.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 18.06.2022.
//

import UIKit

class LikedNewsViewController: BaseViewController<LikedNewsViewModel>, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    lazy var cleanLikedNewsBarButtonItem: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: nil, action: nil)
        v.tintColor = .red
        return v
    }()
    
    var likedIsEmpty: Bool = false
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .likedDidTap, object: nil)
    }
    
    override func performPreSetup() {
        title = "Liked news"
        
        setupViews()
        setBinders()
        
        viewModel
            .getLikedNews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupViews() {
        newsTableView
            .register(NewsTableViewCell.uiNib(), forCellReuseIdentifier: NewsTableViewCell.identifire)
        
        newsTableView
            .rx
            .setDelegate(self)
            .disposed(by: defaultDisposeBag)
        
        navigationItem.rightBarButtonItem = cleanLikedNewsBarButtonItem
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        viewModel.getLikedNews()
    }
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 40))
        label.text = "No liked news"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    private func setBinders() {
        
        viewModel
            .likedNews
            .do(onNext: { [weak self] news in
                DispatchQueue.main.async {
                    if news.isEmpty {
                        self?.view.addSubview(self?.emptyStateLabel ?? UIView())
                        self?.emptyStateLabel.center = self?.view.center ?? CGPoint(x: kScreenWidth/2, y: kScreenHeight/2)
                    } else {
                        self?.emptyStateLabel.removeFromSuperview()
                    }
                    self?.likedIsEmpty = news.isEmpty
                }
            })
                .bind(to: newsTableView
                    .rx
                    .items(cellIdentifier: NewsTableViewCell.identifire, cellType: NewsTableViewCell.self)) { [weak self] row, item, cell in
                        cell.configure(with: item)
                        cell.newsIsLiked = true
                        cell.viewModel = NewsTableViewCellViewModel()
                        if self?.refreshControl.isRefreshing == true {
                            self?.refreshControl.endRefreshing()
                        }
                    }.disposed(by: defaultDisposeBag)
        
        newsTableView
            .rx
            .modelSelected(NewsRealmModel.self)
            .subscribe(onNext: { [weak self] item in
                self?.viewModel.openWebPage(urlString: item.url ?? "", title: (item.source?.name ?? item.title) ?? "")
            }).disposed(by: defaultDisposeBag)
        
        cleanLikedNewsBarButtonItem
            .performWhemTap { [weak self] in
                if self?.likedIsEmpty == false {
                    self?.showConfirmationAlert {
                        self?.viewModel.deleteAllLikedNews()
                        self?.refresh()
                    }
                } else {
                    self?.showToast("List is empty")
                }
            }.disposed(by: defaultDisposeBag)
        
        
        NotificationCenter.default.addObserver(forName: .likedDidTap, object: nil, queue: .main) { [weak self] _ in
            self?.refresh()
        }
    }
    
    func showConfirmationAlert(acceptAction: @escaping (() -> Void)) {
        let alert = UIAlertController(title: "Clean all liked news from the list?", message: "If you you press \"Yes\" all liked news will removed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            acceptAction()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}
