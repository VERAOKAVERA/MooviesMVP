// Moovie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

struct Film: Decodable {
    var results: [Results]
    let totalResults: Int
    let totalPages: Int
    let page: Int
}
