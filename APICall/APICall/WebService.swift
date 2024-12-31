//
//  WebService.swift
//  APICall
//
//  Created by Nishanth on 07/08/24.
//

import Foundation


enum BaseURL: String{
    case apiUrl = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM"
}

enum NetworkError: String, LocalizedError{
    case urlNotFound
    case noDataFound
    case decodeError
    case somethinghappend
    case networkNotrechable
    
    var localizedError: String{
        switch self {
        case .urlNotFound:
            return "URL Not Found"
        case .noDataFound:
            return "No Data Found"
        case .somethinghappend:
            return "Please try Again"
        case .networkNotrechable:
            return "Network Not Reachable"
        case .decodeError:
            return "Decoding Error"
        }
    }
    
}

enum HttpMethod: String{
    case get = "GET"
    case post = "POST"
}

class ApiRequest<T: Codable>{
    var urlString: String
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
    
    init(urlString: String){
        self.urlString = urlString
    }
    
}

protocol APIRequestBuilderProtocol{
    
    func webRequest<T>(request: ApiRequest<T>) async throws -> T
}



final class WebService: APIRequestBuilderProtocol{
   
   
    static let sharedInstance = WebService()
    private init(){}
    
    func webRequest<T>(request: ApiRequest<T>) async throws -> T{
        guard let urlString = URL(string: request.urlString) else{
            
            throw NetworkError.urlNotFound
        }
        var urlRequest = URLRequest(url: urlString)
        urlRequest.httpMethod = request.httpMethod.rawValue
        if(request.body != nil){
            urlRequest.httpBody = request.body
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
               throw NetworkError.noDataFound
           }
       
        do {
               let decoder = try JSONDecoder().decode(T.self, from: data)
               return decoder
           } catch {
               throw NetworkError.decodeError
           }
        
    }
    
    
    
    
   
    
}
