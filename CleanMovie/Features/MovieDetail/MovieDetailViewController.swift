//
//  MovieDetailViewController.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift

class MovieDetailViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 12
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let ratingLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .systemOrange
        $0.textAlignment = .center
    }
    
    private let releaseDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
    }
    
    private let runtimeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
    }
    
    private let genreLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemBlue
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let overviewTitleLabel = UILabel().then {
        $0.text = "줄거리"
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    private let overviewLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textColor = .label
    }
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    
    private let errorView = UIView()
    private let errorLabel = UILabel().then {
        $0.text = "영화 정보를 불러올 수 없습니다"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let retryButton = UIButton(type: .system).then {
        $0.setTitle("다시 시도", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - Properties
    private var viewModel: MovieDetailViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        loadMovieData()
    }
    
    func configure(with viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Data Loading
    private func loadMovieData() {
        guard let viewModel else { return }
        
        viewModel.loadMovie()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupLayout()
        setupErrorView()
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        
        // 뒤로 가기 버튼 스타일링
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        view.addSubview(errorView)
        
        scrollView.addSubview(contentView)
        
        [posterImageView, titleLabel, ratingLabel, releaseDateLabel,
         runtimeLabel, genreLabel, overviewTitleLabel, overviewLabel].forEach {
            contentView.addSubview($0)
        }
        
        // ScrollView Layout
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        // Content Layout
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        runtimeLabel.snp.makeConstraints {
            $0.top.equalTo(releaseDateLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(runtimeLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        overviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(genreLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(overviewTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        // Loading Indicator
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // Error View
        errorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    private func setupErrorView() {
        [errorLabel, retryButton].forEach {
            errorView.addSubview($0)
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        retryButton.snp.makeConstraints {
            $0.top.equalTo(errorLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
        
        errorView.isHidden = true
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        // Output 바인딩
        viewModel.movie
            .drive(onNext: { [weak self] movie in
                self?.configureUI(with: movie)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] errorMessage in
                if let error = errorMessage {
                    self?.showError(error)
                } else {
                    self?.hideError()
                }
            })
            .disposed(by: disposeBag)
        
        // Input 바인딩 - 재시도 버튼
        retryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.loadMovie()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI(with movie: Movie?) {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.title
        ratingLabel.text = "★ \(movie.ratingText)"
        releaseDateLabel.text = movie.formattedReleaseDate
        overviewLabel.text = movie.overview.isEmpty ? "줄거리 정보가 없습니다." : movie.overview
        
        // 런타임 표시 (상세 정보에서만 제공)
        if let formattedRuntime = movie.formattedRuntime {
            runtimeLabel.text = "상영시간: \(formattedRuntime)"
            runtimeLabel.isHidden = false
        } else {
            runtimeLabel.isHidden = true
        }
        
        // 장르 표시 (상세 정보에서만 제공)
        if !movie.genres.isEmpty {
            genreLabel.text = movie.genreText
            genreLabel.isHidden = false
        } else {
            genreLabel.isHidden = true
        }
        
        // 포스터 이미지 (실제 구현에서는 이미지 로딩 라이브러리 사용)
        if let posterURL = movie.posterURL {
            loadPosterImage(from: posterURL)
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }
        
        // 네비게이션 타이틀 설정
        navigationItem.title = movie.title
    }
    
    private func loadPosterImage(from urlString: String) {
        // 실제 구현에서는 Kingfisher, SDWebImage 등 사용
        // 여기서는 시스템 이미지로 대체
        posterImageView.image = UIImage(systemName: "photo.artframe")
        
        // TODO: 실제 이미지 로딩 구현
        // posterImageView.kf.setImage(with: URL(string: urlString))
    }
    
    private func showLoading() {
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
        errorView.isHidden = true
    }
    
    private func hideLoading() {
        loadingIndicator.stopAnimating()
        scrollView.isHidden = false
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorView.isHidden = false
        scrollView.isHidden = true
    }
    
    private func hideError() {
        errorView.isHidden = true
        scrollView.isHidden = false
    }
    
    deinit {
        print("MovieDetailViewController deinit")
    }
}
