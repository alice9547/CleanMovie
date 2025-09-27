//
//  LoadingManager.swift
//  CleanMovie
//
//  Created by 김은서 on 9/27/25.
//

import UIKit
import SnapKit
import Then

class LoadingManager {
    static let shared = LoadingManager()
    
    private var loadingView: UIView?
    private var loadingCount = 0
    private let queue = DispatchQueue(label: "LoadingManager", qos: .userInitiated)
    
    private init() {}
    
    func show() {
        queue.async { [weak self] in
            DispatchQueue.main.async {
                self?.showInternal()
            }
        }
    }
    
    func hide() {
        queue.async { [weak self] in
            DispatchQueue.main.async {
                self?.hideInternal()
            }
        }
    }
    
    private func showInternal() {
        loadingCount += 1
        
        if loadingView == nil {
            createLoadingView()
        }
    }
    
    private func hideInternal() {
        loadingCount = max(0, loadingCount - 1)
        
        if loadingCount == 0 {
            removeLoadingView()
        }
    }
    
    private func createLoadingView() {
        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?
            .windows
            .filter({$0.isKeyWindow})
            .first else { return }
        
        
        let loadingView = UIView().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        
        let containerView = UIView().then {
            $0.backgroundColor = .systemBackground
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        let indicator = UIActivityIndicatorView(style: .large).then {
            $0.startAnimating()
        }
        
        let label = UILabel().then {
            $0.text = "로딩 중..."
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textColor = .label
            $0.textAlignment = .center
        }
        
        loadingView.addSubview(containerView)
        containerView.addSubview(indicator)
        containerView.addSubview(label)
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(100)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(indicator.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        window.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.loadingView = loadingView
    }
    
    private func removeLoadingView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingView?.alpha = 0
        }) { _ in
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}
