//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Scaltiel Gloria on 26/01/25.
//


import RxSwift
import RxCocoa
import UIKit

class MovieDetailsViewModel {
    private let disposeBag = DisposeBag()
    private let movieService = APIClient()

    let movieDetails = BehaviorRelay<MovieDetails?>(value: nil)
    let reviews = BehaviorRelay<[Review]>(value: [])
    let officialTrailerURL = BehaviorRelay<String?>(value: nil)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<Error>()

    func fetchMovieDetails(movieId: Int) {
        isLoading.accept(true)

        let detailsObservable = movieService.fetchMovieDetails(movieId: movieId)
        let reviewsObservable = movieService.fetchMovieReviews(movieId: movieId, page: 1)
        let trailersObservable = movieService.fetchMovieTrailers(movieId: movieId)

        Observable.zip(detailsObservable, reviewsObservable, trailersObservable)
            .subscribe(onNext: { [weak self] details, reviews, trailers in
                self?.movieDetails.accept(details)
                self?.reviews.accept(reviews)

                if let officialTrailer = trailers.first(where: { $0.name.lowercased().contains("official trailer") }) {
                    self?.officialTrailerURL.accept("https://www.youtube.com/embed/\(officialTrailer.key)")
                }

                self?.isLoading.accept(false)
            }, onError: { [weak self] error in
                self?.error.onNext(error)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
}

