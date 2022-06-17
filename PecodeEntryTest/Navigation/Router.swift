//
//  Router.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 15.06.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func popViewController()
    func dismissVC()
    
    func initial()
    func presentSearchSettings()
    func openWeb(url: URL, title: String)
    
}

class Router: RouterProtocol {
    
    
     var navigationController: UINavigationController?
     var assemblyBuilder: AssemblyBuilderProtocol?
        
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.assemblyBuilder = assemblyBuilder
        self.navigationController = navigationController
        self.setupNavBar()
    }
    
    private func setupNavBar() {
        let nb = navigationController?.navigationBar
        nb?.setBackgroundImage(UIImage(), for: .default)
        nb?.shadowImage = UIImage()
        nb?.barTintColor = UIColor.white
        nb?.tintColor = UIColor.white
        nb?.isHidden = false
        nb?.isTranslucent = true
        navigationController?.navigationItem.hidesBackButton = true
    }
    
    func popViewController() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    func dismissVC() {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: true)
        }
    }

    func initial() {
        if let navigationController = navigationController {
            guard let welcome = assemblyBuilder?.createHomePage(router: self) else { return }
            navigationController.viewControllers = [welcome]
        }
    }
    
    func openWeb(url: URL, title: String) {
        if let navigationController = navigationController {
            guard let webController = assemblyBuilder?.createWebPage(with: url, title: title) else { return }
            navigationController.pushViewController(webController, animated: true)
        }
    }
    
    func presentSearchSettings() {
        if let navigationController = navigationController {
            guard let searchSettings = assemblyBuilder?.createSearchSettingsPage(router: self) else { return }
            navigationController.present(searchSettings, animated: true)
        }
    }
    
}
