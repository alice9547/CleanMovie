//
//  MovieTableViewCell.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation
import UIKit
import Then
import SnapKit

class MovieTableViewCell: UITableViewCell {
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.numberOfLines = 2
        $0.textColor = .label
    }
    
    private let overviewLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 3
    }
    
    private let ratingLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .systemOrange
    }
    
    private let releaseDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .secondaryLabel
    }
    
    private let chevronImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .systemGray3
        $0.contentMode = .scaleAspectFit
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
        ratingLabel.text = nil
        releaseDateLabel.text = nil
    }
    
    private func setupUI() {
        selectionStyle = .default
        
        [posterImageView, titleLabel, overviewLabel, ratingLabel, releaseDateLabel, chevronImageView].forEach {
            contentView.addSubview($0)
        }
        
        posterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(8)
            $0.width.equalTo(70)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            $0.top.equalToSuperview().offset(12)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.trailing.equalTo(titleLabel)
            $0.centerY.equalTo(ratingLabel)
        }
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview.isEmpty ? "줄거리 정보가 없습니다." : movie.overview
        ratingLabel.text = "★ \(movie.ratingText)"
        releaseDateLabel.text = extractYear(from: movie.releaseDate)
        
        // 포스터 이미지 설정 (실제로는 이미지 로딩 라이브러리 사용)
        if let posterURL = movie.posterURL {
            loadPosterImage(from: posterURL)
        } else {
            posterImageView.image = UIImage(systemName: "photo.artframe")
            posterImageView.tintColor = .systemGray3
        }
    }
    
    private func loadPosterImage(from urlString: String) {
        // 실제 구현에서는 Kingfisher, SDWebImage 등 사용
        posterImageView.image = UIImage(systemName: "photo.artframe")
        posterImageView.tintColor = .systemGray3
        
        // TODO: 실제 이미지 로딩 구현
        // posterImageView.kf.setImage(with: URL(string: urlString))
    }
    
    private func extractYear(from dateString: String) -> String {
        if dateString.count >= 4 {
            return String(dateString.prefix(4))
        }
        return dateString
    }
}
