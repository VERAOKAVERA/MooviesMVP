// PosterTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

class PosterTableViewCell: UITableViewCell {
    // MARK: Static Properties

    static let identifier = "PosterTableViewCell"

    // MARK: Private Visual Components

    private let posterImageView = UIImageView()

    // MARK: Set Selected

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupImageView()
    }

    // MARK: Internal Methods

    func configureCell(details: Description, indexPath: IndexPath) {
        guard let posterPath = details.posterPath,
              let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else { return }
        let imageService = ImageService()
        imageService.getImage(url: url) { image in
            self.posterImageView.image = image
        }
    }

    // MARK: Private Methods

    private func setupImageView() {
        addSubview(posterImageView)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            posterImageView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -10
            ),
            posterImageView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 10
            ),
            posterImageView.heightAnchor.constraint(equalToConstant: 400),
            posterImageView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -5
            )
        ])
    }
}
