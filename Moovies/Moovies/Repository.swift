// Repository.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

// дженерик протокол без ассоциативных типов
// Паттерн репозиторий позволяет абстрогоритьваться от БД и в дальнейшем ее подменять
// 1)
protocol DatabaseProtocol {
    // 2)создаем ассоциативный тип
    //    associatedtype Entity
    func get(movieType: MoviesType) -> [Movie]
    func add(object: [Movie], movieType: MoviesType)
    func remove(id: Int)
    func removeAll()
}

final class CoreDataMovies: DatabaseProtocol {
    let coreDataService = CoreDataService.shared
    // В данном случае тип Entity соответствует реализации которую мы выберем ( по типу дженерика )
    // 4.1)
    //    typealias Entity = Movies
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

// реализуем класс который рабоатет с CoreData
// 4)
final class RealmMovies: DatabaseProtocol {
    // В данном случае тип Entity соответствует реализации которую мы выберем ( по типу дженерика )
    // 4.1)
    typealias Entity = [Movie]
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

// Нужно добавить Presenter
// Мы должны добавить вложенный дженерик\. иначе компилятор будет ругаться
// 5) и 5.1)
final class Repository {
    var dataBase: DatabaseProtocol
    init(dataBase: DatabaseProtocol) {
        self.dataBase = dataBase
    }

    func getMovie(movieType: MoviesType) -> [Movie] {
        return dataBase.get(movieType: movieType)
    }

    func save(obj: [Movie], movieType: MoviesType) {
        dataBase.add(object: obj, movieType: movieType)
    }

    func deleteAll() {
        dataBase.removeAll()
    }
}

// final class Repository {
//    // 6)
//    // реализуем сущность презентера и указываем тип CoreData
//    let presenterCoreData = DataPresenter<CoreDataMovies>(dataBase: CoreDataMovies())
//    let presenterRealm = DataPresenter<RealmMovies>(dataBase: RealmMovies())
//    func realmPresentor() {}
// }
