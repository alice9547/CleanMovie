//
//  ActivityIndicator.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation
import RxSwift
import RxCocoa

class ActivityIndicator {
    private let _loading = BehaviorRelay<Bool>(value: false)
    private let _lock = NSRecursiveLock()
    
    fileprivate func trackActivity<O: ObservableConvertibleType>(source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(
                onNext: { _ in },
                onError: { _ in self.sendStopLoading() },
                onCompleted: { self.sendStopLoading() },
                onSubscribe: { self.sendStartLoading() }
            )
    }
    
    private func sendStartLoading() {
        _lock.lock()
        _loading.accept(true)
        _lock.unlock()
    }
    
    private func sendStopLoading() {
        _lock.lock()
        _loading.accept(false)
        _lock.unlock()
    }
    
    func asDriver() -> Driver<Bool> {
        return _loading.asDriver()
    }
}

extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivity(source: self)
    }
}
