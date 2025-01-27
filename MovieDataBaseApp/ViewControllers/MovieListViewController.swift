//
//  ViewController.swift
//  MovieDataBaseApp
//
//  Created by Scaltiel Gloria on 25/01/25.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = MovieListViewModel()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width-60) / 2, height: 250)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 20, bottom: 16, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MoviePosterCell.self, forCellWithReuseIdentifier: "MoviePosterCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let loadingOverlay: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.isHidden = true
        return overlay
    }()

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Movies"
        navigationItem.largeTitleDisplayMode = .always
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchMovies()
    }

    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(loadingOverlay)
        loadingOverlay.addSubview(activityIndicator)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingOverlay.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
        ])
        collectionView.delegate = self
    }

    private func setupBindings() {
        viewModel.movies
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: "MoviePosterCell", cellType: MoviePosterCell.self)) { row, movie, cell in
                cell.configure(with: movie)
            }
            .disposed(by: disposeBag)

        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }

                if isLoading {
                    DispatchQueue.main.async {
                        self.loadingOverlay.isHidden = false
                        self.activityIndicator.startAnimating()
                        self.collectionView.isUserInteractionEnabled = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.loadingOverlay.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.collectionView.isUserInteractionEnabled = true
                    }
                }
            })
            .disposed(by: disposeBag)

        collectionView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self else { return }
                let itemCount = self.viewModel.movies.value.count
                if indexPath.row == itemCount - 1 {
                    self.viewModel.fetchMovies()
                }
            })
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

// MARK: - UICollectionViewDelegate
extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movies.value[indexPath.row]
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieId = selectedMovie.id
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
