// Proxy.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol LoadImageProtocol {
    func loadImage(url: URL, completion: @escaping (Swift.Result<UIImage, Error>) -> Void)
}

final class Proxy: LoadImageProtocol {
    // MARK: - Private Properties

    private let imageAPIService: ImageAPIServiceProtocol
    private let cacheImageService: CacheImageServiceProtocol

    // MARK: - Init

    init(service: ImageAPIServiceProtocol, cacheImageService: CacheImageServiceProtocol) {
        imageAPIService = service
        self.cacheImageService = cacheImageService
    }

    // MARK: - Public Methods

    func loadImage(url: URL, completion: @escaping (Swift.Result<UIImage, Error>) -> Void) {
        let image = cacheImageService.getImageFromCache(url: url.absoluteString)

        if image == nil {
            imageAPIService.getPhoto(url: url) { result in
                switch result {
                case let .success(image):
                    self.cacheImageService.saveImageToCache(url: url.absoluteString, image: image)
                    completion(.success(image))
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        } else {
            guard let image = image else { return }
            completion(.success(image))
        }
    }
}
