// MoovieApiService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

protocol MovieAPIServiceProtocol {
    func getMoviesOfTypeService(_ type: String, completion: @escaping (Result<[Results], Error>) -> Void)
    func getMovieDescriptionService(id: Int, completion: @escaping (Result<Description, Error>) -> Void)
}

final class MovieAPIService: MovieAPIServiceProtocol {
    private let baseURL = "https://api.themoviedb.org"
    private let urlPath = "/3/movie"
    private let APIKey = "9ad7d04f6206bfa729848e1f3f2ffb2d"
    private let language = "ru-RU"
    private let page = "1"

    func getMovieDescriptionService(id: Int, completion: @escaping (Result<Description, Error>) -> Void) {
        let URL = baseURL + urlPath + "/\(id)"

        let parameters: [String: Any] = [
            "api_key": APIKey,
            "language": language
        ]

        AF.request(URL, parameters: parameters).validate().responseData(queue: .global(qos: .utility)) { response in
            switch response.result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let description = try decoder.decode(Description.self, from: data)
                    let details = description
                    completion(.success(details))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getMoviesOfTypeService(_ type: String, completion: @escaping (Result<[Results], Error>) -> Void) {
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
