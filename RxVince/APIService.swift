//
//  APIService.swift
//  RxVince
//
//  Created by Vincent Restrepo on 5/22/19.
//  Copyright © 2019 Vincent Restrepo. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    typealias webServiceResponse = ([[String : Any]]?, Error?) -> Void
    
    func execute(_ url : URL, completion : @escaping webServiceResponse) {
        
        //var urlRequest = URLRequest(url : url)
        //urlRequest.httpMethod = "GET"
        
        Alamofire.request(url).validate()
            .responseJSON(completionHandler: { response in
                if let error = response.error {
                    completion(nil, error)
                } else if let jsonArray  = response.result.value as? [[String : Any]] {
                    completion(jsonArray, nil)
                } else if let jsonDict = response.result.value as? [String : Any] {
                    completion([jsonDict], nil)
                }
            })
    }
    
}
