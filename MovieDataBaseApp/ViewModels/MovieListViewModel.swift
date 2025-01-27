//
//  MovieListViewModel.swift
//  Movies
//
//  Created by Scaltiel Gloria on 26/01/25.
//


import RxSwift
import RxCocoa
import UIKit

class MovieListViewModel {
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()

    let movies = BehaviorRelay<[Movie]>(value: [])
    let topRatedMovies = BehaviorRelay<[Movie]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<Error>()
    private var currentPage = 1
    private var totalPages = 1

    func fetchMovies() {
        guard currentPage <= totalPages, !isLoading.value else { return }

        isLoading.accept(true)

        apiClient.fetchMovies(page: currentPage)
            .subscribe(onNext: { [weak self] movies, totalPages in
                guard let self = self else { return }
                self.movies.accept(self.movies.value + movies)
                self.currentPage += 1
                self.totalPages = totalPages
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.error.onNext(error)
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }

    func fetchTopRatedMovies() {
        apiClient.fetchTopRatedMovies()
            .subscribe(onNext: { [weak self] movies in
                guard let self = self else { return }
                self.topRatedMovies.accept(movies)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.error.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}

