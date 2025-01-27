//
//  ReviewCell.swift
//  Movies
//
//  Created by Scaltiel Gloria on 26/01/25.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit
import SDWebImage


class ReviewCell: UICollectionViewCell {
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()

    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(reviewLabel)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),

            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            reviewLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            reviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with review: Review) {
        authorLabel.text = review.author
        reviewLabel.text = review.content
        if let avatarURL = review.authorDetails.avatarPath {
            let fullAvatarURL = "https://image.tmdb.org/t/p/w500\(avatarURL)"
            avatarImageView.sd_setImage(with: URL(string: fullAvatarURL), placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
    }
}
