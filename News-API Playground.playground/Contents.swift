//: ## MARK: News API https://newsapi.org

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

//API Query Parameters with sample values
let search = URLQueryItem(name: "q", value: "uber")
let fromDate = URLQueryItem(name: "from", value: "2018-07-14")  // needs to be converted to Date
let toDate = URLQueryItem(name: "to", value: "2018-07-17") // needs to be converted to Date
let sortBy = URLQueryItem(name: "sortBy", value: SortOptions.publishedAt.rawValue) //should be an enum with options
let language = URLQueryItem(name: "language", value: "en")
let country = URLQueryItem(name: "country", value: "us")
let sourcesName = URLQueryItem(name: "sources", value: "bbc-news")

//: API Key, This is a unique key that identifies your requests. They're free for development, open-source, and non-commercial use. You can get one here: https://newsapi.org

let secretAPIKey = URLQueryItem(name: "apiKey", value: "")

//MARK: Samples EndPoints as per News API suggestions

//Top headlines in the US
func topHeadlines() -> URL?  {
    topHeadLinesUrl?.queryItems?.append(country)
    topHeadLinesUrl?.queryItems?.append(secretAPIKey)
    return topHeadLinesUrl?.url
}


//Top headlines from BBC News
func topHeadlinesBBCNews() -> URL? {
    topHeadLinesUrl?.queryItems?.append(sourcesName)
    topHeadLinesUrl?.queryItems?.append(secretAPIKey)
    return topHeadLinesUrl?.url
}

//Object that keeps the news feed
var myFeed: [NewsSource.Article] = []
var errorMessage = ""

//Networking Code
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601

fileprivate func updateResults(_ data: Data) {
    myFeed.removeAll()
    do {
        let rawFeed = try decoder.decode(NewsSource.self, from: data)
        myFeed = rawFeed.articles
    } catch let decodeError as NSError {
        errorMessage += "Decoder error: \(decodeError.localizedDescription)"
        return
    }
}

func getResults(from url: URL, completion: @escaping () -> ()) {
    URLSession.shared.dataTask(with: url) { (data, response, error ) in
        guard let data = data else { return }
        updateResults(data)
        completion()
        }.resume()
}

//Get Result and print result once the data has download.
//getResults(from: topHeadlines()!) {
//    DispatchQueue.main.async {
//        myFeed.forEach{
//            print("Title: \($0.title ?? "No Title") - \($0.publishedAt), \($0.source.id?.capitalized ?? "null")")
//            print("SourceURL: \(String(describing: $0.url)) Image: \(String(describing: $0.urlToImage))")
//        }
//    }
//}


getResults(from: topHeadlinesBBCNews()!) {
    DispatchQueue.main.async {
        myFeed.forEach{
            print("Title: \($0.title ?? "No Title") - \($0.publishedAt), \($0.source.id?.capitalized ?? "null")")
            print("SourceURL: \(String(describing: $0.url)) Image: \(String(describing: $0.urlToImage))")
        }
    }
}
