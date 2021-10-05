// Result.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

struct Result: Decodable {
    var posterPath: String?
    let overview: String
    let title: String
    let releaseDate: String
    let id: Int
    let voteAverage: Float
}
