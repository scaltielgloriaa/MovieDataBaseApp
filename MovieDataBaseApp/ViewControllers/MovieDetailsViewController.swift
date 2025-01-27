//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Scaltiel Gloria on 26/01/25.
//


import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import WebKit


class MovieDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = MovieDetailsViewModel()
    var movieId: Int!

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()

    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let reviewsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reviews"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let reviewsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 200)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: "ReviewCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let trailerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trailer"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let trailerWebView: WKWebView = {
        let webView = WKWebView()
        webView.layer.cornerRadius = 8
        webView.clipsToBounds = true
        return webView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let noReviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "No reviews available."
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()

    private let noTrailerLabel: UILabel = {
        let label = UILabel()
        label.text = "No trailer available."
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchMovieDetails(movieId: movieId)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(reviewsTitleLabel)
        contentView.addSubview(reviewsCollectionView)
        contentView.addSubview(trailerTitleLabel)
        contentView.addSubview(trailerWebView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(noReviewsLabel)
        contentView.addSubview(noTrailerLabel)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trailerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        trailerWebView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        noReviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        noTrailerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.heightAnchor.constraint(equalToConstant: 180),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            reviewsTitleLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 16),
            reviewsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reviewsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            reviewsCollectionView.topAnchor.constraint(equalTo: reviewsTitleLabel.bottomAnchor, constant: 8),
            reviewsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reviewsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reviewsCollectionView.heightAnchor.constraint(equalToConstant: 200),

            trailerTitleLabel.topAnchor.constraint(equalTo: reviewsCollectionView.bottomAnchor, constant: 16),
            trailerTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trailerTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            trailerWebView.topAnchor.constraint(equalTo: trailerTitleLabel.bottomAnchor, constant: 8),
            trailerWebView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trailerWebView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trailerWebView.heightAnchor.constraint(equalToConstant: 200),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            trailerWebView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            noReviewsLabel.topAnchor.constraint(equalTo: reviewsTitleLabel.bottomAnchor, constant: 80),
            noReviewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noReviewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            noReviewsLabel.heightAnchor.constraint(equalToConstant: 50),

            noTrailerLabel.topAnchor.constraint(equalTo: trailerTitleLabel.bottomAnchor, constant: 80),
            noTrailerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noTrailerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            noTrailerLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupBindings() {
        viewModel.movieDetails
            .subscribe(onNext: { [weak self] details in
                guard let details = details else {
                    print("Error: Movie details are nil")
                    return
                }
                DispatchQueue.main.async {
                    self?.titleLabel.text = details.title
                    self?.overviewLabel.text = details.overview
                    self?.releaseDateLabel.text = "Release Date: \(details.releaseDate)"
                    let imageURL = "https://image.tmdb.org/t/p/w500\(details.posterPath)"
                    self?.posterImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder"))
                }
            })
            .disposed(by: disposeBag)

        viewModel.reviews
            .bind(to: reviewsCollectionView.rx.items(cellIdentifier: "ReviewCell", cellType: ReviewCell.self)) { row, review, cell in
                cell.configure(with: review)
            }
            .disposed(by: disposeBag)

        viewModel.reviews
            .subscribe(onNext: { [weak self] reviews in
                DispatchQueue.main.async {
                    if reviews.isEmpty {
                        self?.noReviewsLabel.isHidden = false
                        self?.reviewsCollectionView.isHidden = true
                    } else {
                        self?.noReviewsLabel.isHidden = true
                        self?.reviewsCollectionView.isHidden = false
                    }
                }
            })
            .disposed(by: disposeBag)


        viewModel.officialTrailerURL
            .subscribe(onNext: { [weak self] url in
                DispatchQueue.main.async {
                    if let url = url, let trailerURL = URL(string: url) {
                        self?.trailerWebView.isHidden = false
                        self?.noTrailerLabel.isHidden = true
                        self?.trailerWebView.load(URLRequest(url: trailerURL))
                    } else {
                        self?.trailerWebView.isHidden = true
                        self?.noTrailerLabel.isHidden = false
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.error
            .subscribe(onNext: { [weak self] error in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}
