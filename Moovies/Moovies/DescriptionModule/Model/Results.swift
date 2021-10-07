// Results.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

struct PageDataMovie {
    var movies: [Film]
}

extension PageDataMovie: Decodable {
    private enum MovieCodingKeys: String, CodingKey {
        case movies = "results"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieCodingKeys.self)
        movies = try container.decode([Film].self, forKey: .movies)
    }
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

struct Results: Decodable {
    var posterPath: String?
    let overview: String
    let title: String
    let releaseDate: String
    let id: Int
    let voteAverage: Float
}
