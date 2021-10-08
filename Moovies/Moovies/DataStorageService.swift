// DataStorageService.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

protocol AccessableRepository {}

protocol DataStorageServiceProtocol {
    func save(object: [Movie], movieType: MoviesType)
    func get(movieType: MoviesType) -> [Movie]
    func removeAll()
}

// DataStorageService
final class DataStorageService: DataStorageServiceProtocol {
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

    static let shared = DataStorageService()

    private init() {}
}
