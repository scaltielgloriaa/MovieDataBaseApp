//
//  MoviePosterCell.swift
//  Movies
//
//  Created by Scaltiel Gloria on 26/01/25.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class MoviePosterCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        let imageURL = "https://image.tmdb.org/t/p/w500\(movie.posterPath)"
        imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(systemName: "photo.fill.on.rectangle.fill"))
    }
}
