//
//  TrailerCell.swift
//  Movies
//
//  Created by Scaltiel Gloria on 26/01/25.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

class TrailerCell: UICollectionViewCell {
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.layer.cornerRadius = 8
        webView.clipsToBounds = true
        return webView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with trailerURL: String) {
        if let url = URL(string: trailerURL) {
            webView.load(URLRequest(url: url))
        }
    }
}
