// ImageService.swift
// Copyright © RoadMap. All rights reserved.

//
//  ImageService.swift
//  Moovies
//
//  Created by Vera Zaitseva on 07.10.2021.
//
import UIKit

protocol ImageServiceProtocol {
    func getImage(url: URL, completion: @escaping (UIImage) -> ())
}

final class ImageService: ImageServiceProtocol {
//    static let shared = ImageService()

    // MARK: - Public Methods

    func getImage(url: URL, completion: @escaping (UIImage) -> ()) {
        let imageAPIService = ImageAPIService()
        let cacheImageService = CacheImageService()
        let proxy = Proxy(imageAPIService: imageAPIService, cacheImageService: cacheImageService)

        proxy.loadImage(url: url) { result in
            switch result {
            case let .success(image):
                completion(image)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
