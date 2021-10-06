// MoovieDescription.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

struct Description: Decodable {
    var posterPath: String?
    let title: String
    let overview: String
}
