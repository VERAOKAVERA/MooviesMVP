// DataStorageService.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

protocol AccessableRepository {}

protocol DataStorageServiceProtocol {
    func save(object: [Movie], movieType: MoviesType)
    func get(movieType: MoviesType) -> [Movie]
    func getDescription(id: Int) -> [Description]
    func saveDescription(object: [Description], id: Int)
    func removeAll()
}

// DataStorageService
final class DataStorageService: DataStorageServiceProtocol {
    func getDescription(id: Int) -> [Description] {
        repository.getMovieDescription(id: id)
    }

    func saveDescription(object: [Description], id: Int) {
        repository.dataBase.addDescription(object: object, id: id)
    }

    private let repository = Repository(dataBase: CoreDataMovies())

    func save(object: [Movie], movieType: MoviesType) {
        repository.save(obj: object, movieType: movieType)
    }

    func get(movieType: MoviesType) -> [Movie] {
        return repository.getMovie(movieType: movieType)
    }

    func removeAll() {
        repository.deleteAll()
    }

    // MARK: - Core Data stack

//    static let shared = DataStorageService()
}

final class DetailsDataStorageService: DataStorageServiceProtocol {
    func getDescription(id: Int) -> [Description] {
        return repository.getMovieDescription(id: id)
    }

    func saveDescription(object: [Description], id: Int) {}

    func save(object: [Movie], movieType: MoviesType) {}

    private let repository = Repository(dataBase: CoreDataMovies())

    func get(movieType: MoviesType) -> [Movie] {
        return repository.getMovie(movieType: movieType)
    }

    func removeAll() {
        repository.deleteAll()
    }

    // MARK: - Core Data stack

//    static let shared = DetailsDataStorageService()

//    private init() {}
}
