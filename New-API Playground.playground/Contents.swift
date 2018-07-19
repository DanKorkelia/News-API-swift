//MARK: News API https://newsapi.org

import Foundation

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
