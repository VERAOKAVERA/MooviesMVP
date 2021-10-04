// MooviesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

class MooviesViewController: UIViewController {
    // MARK: Private Properties

    private var films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
    var presentor: MainViewPresentorProtocol!

    // MARK: Private Visual Components

    private var segmentControl = UISegmentedControl(items: ["Популярные", "Топ-100", "Скоро"])
    internal var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        getPopularRequest(moovies: films, tableView: tableView)
        setupTableView()
        setupSegmentControl()
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
            getPopularRequest(moovies: films, tableView: tableView)
        case 1:
            // getTopRatedRequest(moovies: films, tableView: tableView)
            presentor?.getTopRatedRequest(moovies: films, tableView: tableView, title: "Топ-фильмов")
        case 2:
            getUpcomingRequest(moovies: films, tableView: tableView)
        default:
            getPopularRequest(moovies: films, tableView: tableView)
        }
    }

    private func setupTableView() {
        title = "Топ-100"
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

    private func getTopRatedRequest(moovies: Film, tableView: UITableView) {
        title = "Топ-100 за все время"
        films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        for page in 1 ... 5 {
            guard let url =
                URL(
                    string: "https://api.themoviedb.org/3/movie/top_rated?api_key=209be2942f86f39dd556564d2ad35c5c&language=ru-RU&page=\(page)"
                )
            else { return }

            URLSession.shared.dataTask(with: url) { data, response, _ in
                guard let usageData = data,
                      let usageResponse = response as? HTTPURLResponse else { return }
                print("status code: \(usageResponse.statusCode)")

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pageMovies = try decoder.decode(Film.self, from: usageData)
                    if self.films.results != nil {
                        self.films.results += pageMovies.results
                    } else {
                        self.films = pageMovies
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error")
                }
            }.resume()
        }
    }

    private func getPopularRequest(moovies: Film, tableView: UITableView) {
        title = "Популярные фильмы"
        films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        for page in 1 ... 5 {
            guard let url =
                URL(
                    string: "https://api.themoviedb.org/3/movie/popular?api_key=209be2942f86f39dd556564d2ad35c5c&language=ru-RU&page=\(page)"
                )
            else { return }

            URLSession.shared.dataTask(with: url) { data, response, _ in
                guard let usageData = data,
                      let usageResponse = response as? HTTPURLResponse else { return }
                print("status code: \(usageResponse.statusCode)")

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pageMovies = try decoder.decode(Film.self, from: usageData)
                    if self.films.results != nil {
                        self.films.results += pageMovies.results
                    } else {
                        self.films = pageMovies
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error")
                }
            }.resume()
        }
    }

    private func getUpcomingRequest(moovies: Film, tableView: UITableView) {
        title = "Скоро на экранах"
        films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        for page in 1 ... 5 {
            guard let url =
                URL(
                    string: "https://api.themoviedb.org/3/movie/upcoming?api_key=209be2942f86f39dd556564d2ad35c5c&language=ru-RU&page=\(page)"
                )
            else { return }

            URLSession.shared.dataTask(with: url) { data, response, _ in
                guard let usageData = data,
                      let usageResponse = response as? HTTPURLResponse else { return }
                print("status code: \(usageResponse.statusCode)")

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pageMovies = try decoder.decode(Film.self, from: usageData)
                    if self.films.results != nil {
                        self.films.results += pageMovies.results
                    } else {
                        self.films = pageMovies
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error")
                }
            }.resume()
        }
    }
}

// MARK: Extension

extension MooviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identificator = films.results[indexPath.row].id
        let descriptionVC = MoovieDescriptionTableViewController()
        descriptionVC.movieID = identificator
        navigationController?.pushViewController(descriptionVC, animated: true)
    }
}

extension MooviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countFilms = films.results.count
        return countFilms
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "mooviesTableViewCell",
            for: indexPath
        ) as? MooviesTableViewCell else { return UITableViewCell() }
        cell.configureCell(films: films, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}
