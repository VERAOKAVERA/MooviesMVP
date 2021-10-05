// MoovieApiService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

protocol MovieAPIServiceProtocol {
    func getMoviesOfType(_ type: MoviesType, completion: @escaping (Result<[Results], Error>) -> Void)
}

final class MovieAPIService: MovieAPIServiceProtocol {
    private let baseURL = "https://api.themoviedb.org"
    private let urlPath = "/3/movie"
    private let APIKey = "9ad7d04f6206bfa729848e1f3f2ffb2d"
    private let language = "ru-RU"
    private let page = "1"

    func getMoviesOfType(_ type: MoviesType, completion: @escaping (Result<[Results], Error>) -> Void) {
        let URL = baseURL + urlPath + "/\(type)"

        let parameters = [
            "api_key": APIKey,
            "language": language,
            "page": page
        ]
        AF.request(URL, parameters: parameters).validate().responseData { response in
            switch response.result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let film = try decoder.decode(Film.self, from: data)
                    let details = film.results
                    completion(.success(details))
                } catch {
                    completion(.failure(error))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
