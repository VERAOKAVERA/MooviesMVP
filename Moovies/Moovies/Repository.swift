// Repository.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

protocol DatabaseProtocol {
    func get(movieType: MoviesType) -> [Movie]
    func getDescription(id: Int) -> [Description]
    func add(object: [Movie], movieType: MoviesType)
    func addDescription(object: [Description], id: Int)
    func remove(id: Int)
    func removeAll()
}

final class CoreDataMovies: DatabaseProtocol {
    private let coreDataService = CoreDataService.shared

    func getDescription(id: Int) -> [Description] {
        return []
    }

    func addDescription(object: [Description], id: Int) {}

    func get(movieType: MoviesType) -> [Movie] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreMovie.self))
        fetchRequest.predicate = NSPredicate(format: "movieType = %i", movieType.rawValue)
        guard let result = try? coreDataService.context.fetch(fetchRequest) as? [CoreMovie] else { return [] }

        let movies = result.map {
            Movie(
                posterPath: $0.posterPath,
                overview: $0.overview,
                title: $0.title,
                releaseDate: $0.releaseDate,
                id: $0.id,
                voteAverage: $0.voteAverage
            )
        }

        return movies
    }

    func add(object: [Movie], movieType: MoviesType) {
        for movie in object {
            let movieModel = CoreMovie(context: coreDataService.context)
            movieModel.id = movie.id
            movieModel.title = movie.title
            movieModel.posterPath = movie.posterPath
            movieModel.overview = movie.overview
            movieModel.releaseDate = movie.releaseDate
            movieModel.voteAverage = movie.voteAverage
            movieModel.movieType = movieType.rawValue
        }
        coreDataService.saveContext()
    }

    func remove(id: Int) {}

    func removeAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreMovie.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? coreDataService.context.execute(deleteRequest)
        coreDataService.saveContext()
    }
}

final class MoviesRealm: DatabaseProtocol {
    func getDescription(id: Int) -> [Description] {
        return []
    }

    func addDescription(object: [Description], id: Int) {}

    func get(movieType: MoviesType) -> [Movie] {
        return [Movie](
            repeating: .init(posterPath: "", overview: "", title: "", releaseDate: "", id: 0, voteAverage: 0),
            count: 10
        )
    }

    func add(object: [Movie], movieType: MoviesType) {}
    func remove(id: Int) {}
    func removeAll() {}
}

protocol Repositorable {
    func getMovie(movieType: MoviesType) -> [Movie]
    func getMovieDescription(id: Int) -> [Description]
    func save(obj: [Movie], movieType: MoviesType)
    func saveDescription(obj: [Description], id: Int)
    func deleteAll()
}

final class Repository: Repositorable {
    var dataBase: DatabaseProtocol
    init(dataBase: DatabaseProtocol) {
        self.dataBase = dataBase
    }

    func getMovie(movieType: MoviesType) -> [Movie] {
        return dataBase.get(movieType: movieType)
    }

    func getMovieDescription(id: Int) -> [Description] {
        return dataBase.getDescription(id: id)
    }

    func save(obj: [Movie], movieType: MoviesType) {
        dataBase.add(object: obj, movieType: movieType)
    }

    func saveDescription(obj: [Description], id: Int) {
        dataBase.addDescription(object: obj, id: id)
    }

    func deleteAll() {
        dataBase.removeAll()
    }
}

final class CoreDataMoviesDetails: DatabaseProtocol {
    func get(movieType: MoviesType) -> [Movie] {
        return []
    }

    let coreDataService = CoreDataService.shared
    func getDescription(id: Int) -> [Description] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreDescription.self))
        fetchRequest.predicate = NSPredicate(format: "movieType = %i", id)
        guard let result = try? coreDataService.context.fetch(fetchRequest) as? [CoreDescription] else { return [] }

        let movies = result.map {
            Description(posterPath: $0.posterPath, title: $0.title, overview: $0.overview)
        }
        return movies
    }

    func addDescription(object: [Description], id: Int) {
        for movie in object {
            let movieModel = CoreDescription(context: coreDataService.context)
            movieModel.title = movie.title
            movieModel.posterPath = movie.posterPath
            movieModel.overview = movie.overview
        }
        coreDataService.saveContext()
    }

    func add(object: [Movie], movieType: MoviesType) {}

    func remove(id: Int) {}

    func removeAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreMovie.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? coreDataService.context.execute(deleteRequest)
        coreDataService.saveContext()
    }
}
