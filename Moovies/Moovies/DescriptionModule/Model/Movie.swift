// Movie.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

struct PageDataMovie {
    var movies: [MoviesResult]
}

extension PageDataMovie: Decodable {
    private enum MovieCodingKeys: String, CodingKey {
        case movies = "results"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieCodingKeys.self)
        movies = try container.decode([MoviesResult].self, forKey: .movies)
    }
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

struct Movie: Decodable {
    var posterPath: String?
    let overview: String
    let title: String
    let releaseDate: String
    let id: Int
    let voteAverage: Float
}

@objc(CoreMovie)
class CoreMovie: NSManagedObject {
    @NSManaged var posterPath: String?
    @NSManaged var overview: String
    @NSManaged var title: String
    @NSManaged var releaseDate: String
    @NSManaged var id: Int
    @NSManaged var movieType: Int
    @NSManaged var voteAverage: Float
}
