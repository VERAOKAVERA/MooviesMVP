//
//  Moovie.swift
//  Moovies
//
//  Created by Vera Zaitseva on 17.08.2021.
//

import Foundation

struct Film: Decodable {
    var results: [Result]
    let totalResults: Int
    let totalPages: Int
    let page: Int
}
