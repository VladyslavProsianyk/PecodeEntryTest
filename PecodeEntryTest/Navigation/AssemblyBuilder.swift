//
//  AssemblyBuilder.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 15.06.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createHomePage(router: RouterProtocol) -> UIViewController
    func createWebPage(with url: URL, title: String) -> UIViewController
    func createSearchSettingsPage(router: RouterProtocol, dismissAction: @escaping (()->Void)) -> UIViewController
    func createLikedNewsPage(router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    
    func createHomePage(router: RouterProtocol) -> UIViewController {
        let view = HomeViewController()
        let viewModel = HomeViewModel()
        view.viewModel = viewModel
        viewModel.router = router
        return view
    }
    
    func createWebPage(with url: URL, title: String) -> UIViewController {
        let viewController = WebController()
        viewController.setupURL(url)
        viewController.title = title
        return viewController
    }
    
    func createSearchSettingsPage(router: RouterProtocol, dismissAction: @escaping (()->Void)) -> UIViewController {
        let view = SerchFilterViewController()
        let viewModel = SerchFilterViewModel()
        view.viewModel = viewModel
        view.dismissAction = dismissAction
        viewModel.router = router
        return view
    }
    
    func createLikedNewsPage(router: RouterProtocol) -> UIViewController {
        let view = LikedNewsViewController()
        let viewModel = LikedNewsViewModel()
        view.viewModel = viewModel
        viewModel.router = router
        return view
    }
}
