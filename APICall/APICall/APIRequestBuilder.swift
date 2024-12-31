//
//  APIRequestBuilder.swift
//  APICall
//
//  Created by Nishanth on 07/08/24.
//

import Foundation


struct APIRequestBuilder{
    
    static var description:ApiRequest<APIResponseModel> = {
        let urlString = BaseURL.apiUrl.rawValue
        
        
        return ApiRequest(urlString: urlString)
    }()
    
}
