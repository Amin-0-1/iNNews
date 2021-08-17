//
//  AllNews+Codable.swift
//  iNNNews
//
//  Created by Amin on 16/07/2021.
//

import Foundation

struct AllNewsResponse: Decodable{
    var status : String?
    var totalResults:Int?
    var articles:[NewsItem]
    
}

struct NewsItem: Decodable ,Hashable{
    static func == (lhs: NewsItem, rhs: NewsItem) -> Bool {
        return lhs.url == rhs.url
    }
    
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct Source: Decodable, Hashable {
    var name:String?
    var id:String?
}
