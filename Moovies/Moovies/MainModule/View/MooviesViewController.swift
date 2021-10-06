// MooviesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MooviesViewController: UIViewController {
    // MARK: Iternal Properties
    var presentor: MainViewPresentorProtocol!

    // MARK: Private Visual Components

    private var segmentControl = UISegmentedControl(items: ["Популярные", "Топ-100", "Скоро"])
    private var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSegmentControl()
        presentor?.getMoviesOfType(.popular)
    }

    // MARK: Private Methods

    private func setupSegmentControl() {
        view.addSubview(segmentControl)
        segmentControl.backgroundColor = .systemPink
        segmentControl.selectedSegmentIndex = 0
        segmentControl.frame = CGRect(x: 10, y: 20, width: 390, height: 50)
        segmentControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
    }

    @objc func segmentedValueChanged(_ sender: UISegmentedControl!) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            presentor?.getMoviesOfType(.popular)
            title = "Популярные"
        case 1:
            presentor?.getMoviesOfType(.topRated)
            title = "Топ-100 рейтинга"
        case 2:
            presentor?.getMoviesOfType(.upcoming)
            title = "Скоро на экранах"

        default: title = "Популярные"
        }
    }

    private func setupTableView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backButtonTitle = ""
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MooviesTableViewCell.self, forCellReuseIdentifier: MooviesTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: Extension

extension MooviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let descriptionVC = ModulesBuilder.buildDetail(
            film: presentor.films.results[indexPath.row],
            id: presentor.films.results[indexPath.row].id
        )
        present(descriptionVC, animated: true)
    }
}

extension MooviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countFilms = presentor.films.results.count
        return countFilms
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "mooviesTableViewCell",
            for: indexPath
        ) as? MooviesTableViewCell else { return UITableViewCell() }
        cell.configureCell(films: presentor.films, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

extension MooviesViewController: MainViewProtocol {
    func reloadTable() {
        tableView.reloadData()
    }
}
