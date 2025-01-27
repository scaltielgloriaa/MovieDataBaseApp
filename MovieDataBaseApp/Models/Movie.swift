//
//  Movie.swift
//  Movies
//
//  Created by Scaltiel Gloria on 26/01/25.
//

import UIKit

struct Movie {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let releaseDate: String
}

extension Movie {
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let title = json["title"] as? String,
              let overview = json["overview"] as? String,
              let posterPath = json["poster_path"] as? String,
              let releaseDate = json["release_date"] as? String else { return nil }
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }
}

struct Review {
    let author: String
    let content: String
    let authorDetails: AuthorDetails

    struct AuthorDetails {
        let avatarPath: String?
    }

    init?(json: [String: Any]) {
        guard let author = json["author"] as? String,
              let content = json["content"] as? String,
              let authorDetailsJSON = json["author_details"] as? [String: Any] else { return nil }

        let avatarPath = authorDetailsJSON["avatar_path"] as? String
        let authorDetails = AuthorDetails(avatarPath: avatarPath)

        self.author = author
        self.content = content
        self.authorDetails = authorDetails
    }
}

struct Trailer {
    let key: String
    let name: String
}

extension Trailer {
    init?(json: [String: Any]) {
        guard let key = json["key"] as? String,
              let name = json["name"] as? String else { return nil }
        self.key = key
        self.name = name
    }
}


struct MovieDetails {
    let title: String
    let year: String
    let released: String
    let plot: String
    let overview: String
    let posterPath: String
    var releaseDate: String

    init(title: String, year: String, released: String, plot: String, overview: String, posterPath: String, releaseDate: String) {
        self.title = title
        self.year = year
        self.released = released
        self.plot = plot
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }

    init?(json: [String: Any]?) {
        guard let json = json,
              let title = json["title"] as? String,
              let releaseDate = json["release_date"] as? String,
              let plot = json["overview"] as? String,
              let overview = json["overview"] as? String,
              let posterPath = json["poster_path"] as? String else {
            return nil
        }

        self.title = title
        self.year = releaseDate.components(separatedBy: "-").first ?? ""
        self.released = releaseDate
        self.plot = plot
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }
}
