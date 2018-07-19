//MARK: News API https://newsapi.org

import Foundation

//Codable Struct to represent JSON payload
struct NewsSource: Codable {
    let status: String?
    let totalResults: Int?
    struct Article: Codable {
        let source: Source
        let author: String?
        let title: String?
        let description: String?
        let url: URL?
        let urlToImage: URL?
        let publishedAt: Date
        
        struct Source: Codable {
            let id: String?
            let name: String?
        }
    }
    
    let articles: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
}

//MARK: Sorting Order Enums
enum SortOptions: String {
    case relevancy // articles more closely related to q come first.
    case popularity // articles from popular sources and publishers come first.
    case publishedAt //newest articles come first.
}

//MARK: URL EndPoints
var topHeadLinesUrl = URLComponents(string: "https://newsapi.org/v2/top-headlines?")
var everythingUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
var sourcesUrl = URLComponents(string: "https://newsapi.org/v2/sources?") // convenience endpoint for tracking publishers

