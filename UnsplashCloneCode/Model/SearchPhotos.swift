// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchPhotos = try? newJSONDecoder().decode(SearchPhotos.self, from: jsonData)

import Foundation

// MARK: - SearchPhotos
struct SearchPhotos: Decodable {
    let total, totalPages: Int
    let results: [Photo]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
