//
//  ToastManager.swift
//  CleanMovie
//
//  Created by 김은서 on 9/27/25.
//

import UIKit
import SnapKit
import Then

class ToastManager {
    static let shared = ToastManager()
    
    private init() {}
    
    func show(message: String, duration: TimeInterval = 3.0) {
        DispatchQueue.main.async {
            self.showToast(message: message, duration: duration)
        }
    }
    
    private func showToast(message: String, duration: TimeInterval) {
        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?
            .windows
            .filter({$0.isKeyWindow})
            .first else { return }
        
        let toast = UIView().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        let label = UILabel().then {
            $0.text = message
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        toast.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        window.addSubview(toast)
        toast.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(window.safeAreaLayoutGuide).offset(-50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        // 애니메이션
        toast.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration - 0.3, options: [], animations: {
                toast.alpha = 0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
}
