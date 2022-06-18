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

class BaseViewController<T: BaseViewModelProtocol>: UIViewController, BaseViewControllerProtocol {
    
    func onFailure(error: Error) {
        handleError(error)
    }
    
    public var viewModel: T!
    
    public typealias ViewModelType = T
    
    public fileprivate(set) lazy var disposeBags: [String: DisposeBag] = ["default": defaultDisposeBag]
    
    public var defaultDisposeBag: DisposeBag! = DisposeBag()
    
    deinit {
        viewModel = nil
        disposeBags.removeAll()
        defaultDisposeBag = nil
        print("\(#function) -- line[\(#line)] -- \((#file as NSString).lastPathComponent)  -- \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preSetup()
        performPreSetup()
   
    }
    
    private func preSetup() {
    
        globalErrorSubject.subscribe(onNext: { [weak self] error in
            self?.onFailure(error: error)
            self?.removeLoading()
            print(error)
        }).disposed(by: defaultDisposeBag)
        
    }
    
    open func performPreSetup() {
        
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideLoading()
    }

    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
}

