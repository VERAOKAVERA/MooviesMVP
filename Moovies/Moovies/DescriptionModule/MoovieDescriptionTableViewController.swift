// MoovieDescriptionTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MoovieDescriptionTableViewController: UITableViewController {
    // MARK: Enum

    enum CellsType {
        case poster
        case overview
    }

    // MARK: Internal Properties

    var movieID = Int()

    // MARK: Private Properties

    private var details: Description?
    private let cells: [CellsType] = [.poster, .overview]
    private let identifires = [PosterTableViewCell.identifier, OverviewTableViewCell.identifier]

    // MARK: Life Cycle View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        detailRequest()
    }

    // MARK: Override Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detail = details else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifires[indexPath.row], for: indexPath)
        title = details?.title
        switch cells[indexPath.row] {
        case .poster:
            guard let posterCell = cell as? PosterTableViewCell else { return UITableViewCell() }
            posterCell.configureCell(details: detail, indexPath: indexPath)
        case .overview:
            guard let overviewCell = cell as? OverviewTableViewCell else { return UITableViewCell() }
            overviewCell.configureCell(details: detail, indexPath: indexPath)
        }
        return cell
    }

    // MARK: Private Methods

    private func setupTableView() {
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.identifier)
        tableView.register(OverviewTableViewCell.self, forCellReuseIdentifier: OverviewTableViewCell.identifier)
    }

    private func detailRequest() {
        guard let url =
            URL(
                string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=209be2942f86f39dd556564d2ad35c5c&language=ru-RU"
            )
        else { return }
        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard let usageData = data,
                  let usageResponse = response as? HTTPURLResponse else { return }
            print("status code: \(usageResponse.statusCode)")

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.details = try decoder.decode(Description.self, from: usageData)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error detail request")
            }
        }.resume()
    }
}
