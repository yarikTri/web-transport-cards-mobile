//
//  CatalogModel.swift
//  yourProjectName
//
//  Created by Yaroslav on 04.12.2023.
//

import Foundation

final class CatalogModel {
    private let catalogNetworkManager = CatalogService.shared
    
    func loadCatalog(with title: String? = nil,
                     completion: @escaping (Result<[CatalogUIModel], Error>) -> Void) {

        catalogNetworkManager.getCatalogData(with: title) { result in
            switch result {
            case .success(let data):
                print("Data: ", data)
                let catalogUIModels = data.routes.map { route in
                    return CatalogUIModel(id: route.id,
                                          name: route.name,
                                          imageUUID: route.imageUUID)
                }
                completion(.success(catalogUIModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
