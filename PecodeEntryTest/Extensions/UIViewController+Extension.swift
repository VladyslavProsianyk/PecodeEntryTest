//
//  UIViewController+Extension.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 15.06.2022.
//

import UIKit
import MBProgressHUD

public var kScreenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
public var kScreenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

private var hub: MBProgressHUD?
private var loadingRefCount = 0

extension UIViewController {

    func showToast(_ text: String, duration: TimeInterval = 3 , completeBlock:(()->())? = nil) {
        DispatchQueue.main.async { [weak self] in
            let hub = MBProgressHUD.showAdded(to: self?.view ?? UIView(), animated: true)
            hub.mode = .text
            hub.label.text = text
            hub.label.numberOfLines = 0
            hub.completionBlock = completeBlock
            hub.hide(animated: true, afterDelay: duration)
        }
    }
    
    func removeLoading() {
        loadingRefCount = 0
        hub?.hide(animated: true)
        hub = nil
    }
    
    func showLoading() {
        loadingRefCount += 1
        if hub == nil {
            hub = MBProgressHUD.showAdded(to: view, animated: true)
            hub?.bezelView.blurEffectStyle = .light
        }
    }
    
    func hideLoading() {
        if hub == nil {
            return
        }
        loadingRefCount -= 1
        if loadingRefCount <= 0 {
            hub?.hide(animated: true)
            hub = nil
        }
    }
}

extension UIViewController {
    func handleError(_ error: Error) {
        showToast(error.localizedDescription)
    }
}

extension UIViewController {
    var navBarPlusStatusBarHeight: CGFloat {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return UINavigationController(rootViewController: UIViewController()).navigationBar.frame.height + 20
        }
        return  UINavigationController(rootViewController: UIViewController()).navigationBar.frame.height + (sceneDelegate.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
    }
}


extension UIView {
    public func animateHidden(_ flag: Bool) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.alpha = !flag ? 1 : 0
        }
    }
}

