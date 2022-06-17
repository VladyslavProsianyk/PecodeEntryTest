//
//  WebControll.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 15.06.2022.
//

import UIKit
import WebKit
import RxSwift

class WebController: BaseViewController<NSNull> {
        
    private(set) lazy var webView: WKWebView = WKWebView(frame: .zero)
        
    fileprivate(set) var url: URL?
    
    fileprivate(set) var request: URLRequest?
    
    fileprivate(set) var header: [String: String]?
        
    override func performPreSetup() {
        setupUI()
        loadUrl(url: url)
    }
    
    func loadUrl(url : URL?) {
        guard let _url = url else {return}
        request = URLRequest(url: _url)
        request?.allHTTPHeaderFields = header
        webView.load(request!)
    }
    
    private func setupUI() {
        view.addSubview(webView)
        
        view.backgroundColor = .white
                
        navigationController?.navigationBar.tintColor = .black
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let guide = self.view.safeAreaLayoutGuide
        webView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        
    }
    
}

extension WebController {
    public func setupURL(_ url: URL?, header: [String: String]? = nil) {
        self.url = url
        self.header = header
    }
    
  
}

