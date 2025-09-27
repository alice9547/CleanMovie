//
//  ViewController.swift
//  CleanArchitecture
//
//  Created by 김은서 on 9/25/25.
//
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class MovieSearchViewController: UIViewController {
    
    // MARK: - UI Components
    private let searchBar = UISearchBar().then {
        $0.placeholder = "영화 제목을 검색하세요"
        $0.searchBarStyle = .minimal
    }
    
    private let tableView = UITableView().then {
        $0.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        $0.rowHeight = 120
        $0.keyboardDismissMode = .onDrag
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .systemBackground
    }
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    
    private lazy var emptyView = SearchEmptyView()
    
    private let errorView = UIView()
    private let errorLabel = UILabel().then {
        $0.text = "검색 중 오류가 발생했습니다"
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
    private var viewModel: MovieSearchViewModel!
    private let disposeBag = DisposeBag()
    
    // Coordinator와 통신
    var onMovieSelected: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func configure(with viewModel: MovieSearchViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupUI() {
        title = "영화 검색"
        view.backgroundColor = .systemBackground
        setupLayout()
        setupErrorView()
    }
    
    private func setupLayout() {
        [searchBar, tableView, loadingIndicator, emptyView, errorView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.center.equalTo(tableView)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        errorView.snp.makeConstraints {
            $0.center.equalTo(tableView)
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
        viewModel.movies
            .do(onNext: { [weak self] movies in
                self?.updateUIState(movies: movies)
            })
            .drive(tableView.rx.items(cellIdentifier: "MovieCell", cellType: MovieTableViewCell.self)) { _, movie, cell in
                cell.configure(with: movie)
            }
            .disposed(by: disposeBag)

        // Input 바인딩
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance) // 입력 지연으로 API 호출 최적화
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.updateSearchQuery(text)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
                self?.viewModel.search()
            })
            .disposed(by: disposeBag)
        
        // 테이블뷰 셀 선택
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                self?.onMovieSelected?(movie.id)
            })
            .disposed(by: disposeBag)
        
        // 셀 선택 해제 애니메이션
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 재시도 버튼
        retryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.search()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI State Management
    private func updateUIState(movies: [Movie]) {
        let hasMovies = !movies.isEmpty
        let hasSearchQuery = !(searchBar.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        
        // 검색 결과가 있으면 테이블뷰 표시
        if hasMovies {
            tableView.isHidden = false
            emptyView.isHidden = true
            errorView.isHidden = true
        }
        // 검색어는 있지만 결과가 없으면 "결과 없음" 표시
        else if hasSearchQuery {
            emptyView.updateForNoResults()
            tableView.isHidden = true
            emptyView.isHidden = false
            errorView.isHidden = true
        }
        // 초기 상태 (검색어 없음)
        else {
            emptyView.updateForInitialState()
            tableView.isHidden = true
            emptyView.isHidden = false
            errorView.isHidden = true
        }
    }
    
    private func handleLoadingState(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            emptyView.isHidden = true
            errorView.isHidden = true
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    private func handleError(_ errorMessage: String?) {
        if let error = errorMessage {
            errorLabel.text = error
            errorView.isHidden = false
            tableView.isHidden = true
            emptyView.isHidden = true
        } else {
            errorView.isHidden = true
        }
    }
    
    deinit {
        onMovieSelected = nil
        print("MovieSearchViewController deinit")
    }
}
