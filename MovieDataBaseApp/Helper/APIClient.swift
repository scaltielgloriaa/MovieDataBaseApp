//
//  APIClient.swift
//  Movies
//
//  Created by Scaltiel Gloria on 26/01/25.
//


import Foundation
import RxSwift
import RxCocoa

class APIClient {
    private let apiKey = "087dd0d5809e9649a366b7e04f7e658b"
    private let baseURL = "https://api.themoviedb.org/3"

    func fetchMovies(page: Int) -> Observable<([Movie], Int)> {
        let urlString = "\(baseURL)/discover/movie?api_key=\(apiKey)&page=\(page)"
        guard let url = URL(string: urlString) else { return Observable.just(([], 0)) }
        
        return URLSession.shared.rx.json(url: url)
            .map { json -> ([Movie], Int) in
                guard let results = json as? [String: Any],
                      let movieData = results["results"] as? [[String: Any]],
                      let totalPages = results["total_pages"] as? Int else { return ([], 0) }
                let movies = movieData.compactMap(Movie.init)
                return (movies, totalPages)
            }
    }

    func fetchMovieDetails(movieId: Int) -> Observable<MovieDetails?> {
        let urlString = "\(baseURL)/movie/\(movieId)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return Observable.just(nil) }

        return URLSession.shared.rx.json(url: url)
            .map { json -> MovieDetails? in
                guard let jsonDict = json as? [String: Any] else { return nil }
                print("movie detail \(jsonDict)")
                return MovieDetails(json: jsonDict)
            }
    }

    func fetchTopRatedMovies() -> Observable<[Movie]> {
        let urlString = "\(baseURL)/movie/top_rated?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return Observable.just([]) }

        return URLSession.shared.rx.json(url: url)
            .map { json -> [Movie] in
                guard let results = json as? [String: Any],
                      let movieData = results["results"] as? [[String: Any]] else { return [] }
                return movieData.compactMap(Movie.init)
            }
    }

    func fetchMovieReviews(movieId: Int, page: Int) -> Observable<[Review]> {
        let urlString = "\(baseURL)/movie/\(movieId)/reviews?api_key=\(apiKey)&page=\(page)"
        guard let url = URL(string: urlString) else { return Observable.just([]) }

        return URLSession.shared.rx.json(url: url)
            .map { json -> [Review] in
                guard let results = json as? [String: Any],
                      let reviewData = results["results"] as? [[String: Any]] else { return [] }
                return reviewData.compactMap(Review.init)
            }
    }

    func fetchMovieTrailers(movieId: Int) -> Observable<[Trailer]> {
        let urlString = "\(baseURL)/movie/\(movieId)/videos?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return Observable.just([]) }
        
        return URLSession.shared.rx.json(url: url)
            .map { json -> [Trailer] in
                guard let results = json as? [String: Any],
                      let trailerData = results["results"] as? [[String: Any]] else { return [] }
                return trailerData.compactMap(Trailer.init)
            }
    }
}

