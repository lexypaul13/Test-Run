//
//  Products.swift
//  Test Run
//
//  Created by Alex Paul on 2/13/22.
//

import Foundation

struct DatabaseResponse: Codable {
    let object: String
    let results: [Result]
    enum CodingKeys: String, CodingKey {
        case object = "object"
        case results = "results"
    }
}

struct Result: Codable {
    
    let properties: Properties
    let lastEditedTime: String
    
    enum CodingKeys: String, CodingKey {
        case properties = "properties"
        case lastEditedTime = "last_edited_time"
    }
}

struct Properties: Codable {
    let tags: Tags
    let name: Name
    enum CodingKeys: String, CodingKey {
        case tags = "Tags"
        case name = "Name"
    }
}

struct Name: Codable {
    let title: [Title]
    enum CodingKeys: String, CodingKey {
        case title = "title"
    }
}

struct Title: Codable {
    let text: Text
    enum CodingKeys: String, CodingKey {
        case text = "text"
    }
}
 
struct Text: Codable {
    let content: String
    enum CodingKeys: String, CodingKey {
        case content = "content"
    }
}

 
struct Tags: Codable {
    let multiSelect: [MultiSelect]
    enum CodingKeys: String, CodingKey {
        case multiSelect = "multi_select"
    }
}

struct MultiSelect: Codable {
    let name: String
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
