//
//  BaseViewController.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 15.06.2022.
//

import RxSwift
import UIKit
import AuthenticationServices

protocol BaseViewControllerProtocol: AnyObject {
    func onFailure(error: Error)
    
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
}

public let globalErrorSubject = PublishSubject<Error>()

class BaseViewController<T>: UIViewController, BaseViewControllerProtocol {
    
    func onFailure(error: Error) {
        self.handleError(error)
    }
    
    public var viewModel: T!
    
    public typealias ViewModelType = T
    
    public fileprivate(set) lazy var disposeBags: [String: DisposeBag] = ["default": self.defaultDisposeBag]
    
    public var defaultDisposeBag: DisposeBag! = DisposeBag()
    
    deinit {
        self.viewModel = nil
        self.disposeBags.removeAll()
        self.defaultDisposeBag = nil
        print("\(#function) -- line[\(#line)] -- \((#file as NSString).lastPathComponent)  -- \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.preSetup()
        self.performPreSetup()
   
    }
    
    private func preSetup() {
    
        globalErrorSubject.subscribe(onNext: { error in
            self.onFailure(error: error)
            self.removeLoading()
            print(error)
        }).disposed(by: self.defaultDisposeBag)
        
    }
    
    open func performPreSetup() {
        
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.hideLoading()
    }

    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
}

