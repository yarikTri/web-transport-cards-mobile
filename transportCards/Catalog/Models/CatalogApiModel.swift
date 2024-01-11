//
//  CatalogApiModel.swift
//  yourProjectName
//
//  Created by Yaroslav on 04.12.2023.
//

import Foundation

struct Route: Codable {
    let id: Int
    let name: String
    let imageUUID: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case imageUUID = "image_uuid"
    }
}

struct CatalogApiModel: Codable {
    let routes: [Route]
    enum CodingKeys: String, CodingKey {
        case routes = "routes"
    }
}
