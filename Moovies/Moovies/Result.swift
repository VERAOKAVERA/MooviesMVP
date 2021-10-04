//
//  Result.swift
//  Moovies
//
//  Created by Vera Zaitseva on 18.08.2021.

import Foundation

struct Result: Decodable {
     var posterPath: String?
     let overview: String
     let title: String
     let releaseDate: String
     let id: Int
     let voteAverage: Float
 }
