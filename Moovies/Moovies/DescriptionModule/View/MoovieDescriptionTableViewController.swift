// MoovieDescriptionTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MoovieDescriptionTableViewController: UITableViewController {
    // MARK: - Enum
    enum CellsType {
        case poster
        case overview
    }

    // MARK: - Internal Properties
    var presentor: DescriptionViewPresentorProtocol!

    // MARK: - Private Properties
    private let cells: [CellsType] = [.poster, .overview]
    private let identifires = [PosterTableViewCell.identifier, OverviewTableViewCell.identifier]

    // MARK: - Life Cycle View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presentor.getMoovieDescription()
    }

    // MARK: - Override Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let details = presentor?.details else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifires[indexPath.row], for: indexPath)
        title = details.title
        switch cells[indexPath.row] {
        case .poster:
            guard let posterCell = cell as? PosterTableViewCell else { return UITableViewCell() }
            posterCell.configureCell(details: details, indexPath: indexPath)
        case .overview:
            guard let overviewCell = cell as? OverviewTableViewCell else { return UITableViewCell() }
            overviewCell.configureCell(details: details, indexPath: indexPath)
        }
        return cell
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.identifier)
        tableView.register(OverviewTableViewCell.self, forCellReuseIdentifier: OverviewTableViewCell.identifier)
    }
}

extension MoovieDescriptionTableViewController: DescriptionViewProtocol {
    func reloadTable() {
        tableView.reloadData()
    }
}
