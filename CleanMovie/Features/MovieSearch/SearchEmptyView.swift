//
//  SearchEmptyView.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import UIKit
import SnapKit
import Then

class SearchEmptyView: UIView {
    
    private let imageView = UIImageView().then {
        $0.tintColor = .systemGray3
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .systemGray2
        $0.textAlignment = .center
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray3
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateForInitialState() // 기본값 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [imageView, titleLabel, subtitleLabel].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - State Updates
    func updateForInitialState() {
        imageView.image = UIImage(systemName: "magnifyingglass")
        titleLabel.text = "검색어를 입력하세요"
        subtitleLabel.text = "영화 제목을 검색해서 정보를 확인해보세요"
    }
    
    func updateForNoResults() {
        imageView.image = UIImage(systemName: "exclamationmark.magnifyingglass")
        titleLabel.text = "검색 결과가 없습니다"
        subtitleLabel.text = "다른 검색어를 입력해보세요"
    }
}
