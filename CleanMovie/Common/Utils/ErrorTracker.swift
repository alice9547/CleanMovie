//
//  ErrorTracker.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ErrorTracker: SharedSequenceConvertibleType {
    public typealias Element = Error?
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let _subject = PublishSubject<Error?>()
    
    deinit {
        _subject.onCompleted()
    }
    
    func trackError<Source: ObservableConvertibleType>(from source: Source) -> Observable<Source.Element> {
        return source.asObservable().do(onError: onError)
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _subject.asObservable().asDriver(onErrorJustReturn: nil)
    }
    
    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
