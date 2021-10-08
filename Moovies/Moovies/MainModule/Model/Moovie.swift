// Moovie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

struct MoviesResult: Decodable {
    var results: [Movie]
    let totalResults: Int
    let totalPages: Int
    let page: Int
}
