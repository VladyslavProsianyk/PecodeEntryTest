//
//  UIBarButtonItem+Extension.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 17.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

extension UIBarButtonItem {
    public func performWhemTap(_ action: (()->Void)?) -> Disposable {
        return rx.tap.subscribe(onNext: { (_) in
            action?()
        })
    }
}
