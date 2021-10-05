// OverviewTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

class OverviewTableViewCell: UITableViewCell {
    // MARK: Static Properties

    static let identifier = "OverviewTableViewCell"

    // MARK: Private Properties

    private let overviewLabel = UILabel()

    // MARK: Set Selected

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupOverviewLabel()
    }

    // MARK: Internal Methods

    func configureCell(details: Description, indexPath: IndexPath) {
        overviewLabel.text = details.overview
    }

    // MARK: Private Methods

    private func setupOverviewLabel() {
        addSubview(overviewLabel)
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.numberOfLines = 0
        overviewLabel.textAlignment = .center
        overviewLabel.sizeToFit()
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            overviewLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)

        ])
    }
}
