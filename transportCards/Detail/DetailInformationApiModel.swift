//
//  DetailInformationApiModel.swift
//  metroStreams
//
//  Created by Yaroslav on 14.12.2023.
//

import Foundation

struct DetailInformationApiModel: Codable {
    let name: String
    let description: String
    let start_station: String
    let end_station: String
    let capacity: Int
    let start_time: String
    let end_time: String
    let interval_minutes: Int
    let image_uuid: String
}
