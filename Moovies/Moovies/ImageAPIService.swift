// ImageAPIService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import AlamofireImage
import UIKit

protocol ImageAPIServiceProtocol {
    func getPhoto(url: URL, completion: @escaping (Swift.Result<UIImage, Error>) -> Void)
}

final class ImageAPIService: ImageAPIServiceProtocol {
    // MARK: - Public Methods

    func getPhoto(url: URL, completion: @escaping (Swift.Result<UIImage, Error>) -> Void) {
        AF.request(url).responseImage { response in
            if case let .success(image) = response.result {
                completion(.success(image))
            }
            if let error = response.error {
                completion(.failure(error))
                return
            }
        }
    }
}
