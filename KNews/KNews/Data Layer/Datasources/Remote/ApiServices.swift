//
//  ApiServices.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 20/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

//protocol ApiServiceType {
//    associatedtype T
//    func fetchData<M :Codable>(target: T,responseClass : M.Type, completion:@escaping (Result<M?, NSError>) -> Void)
//}

class ApiServices<T : ApiRequestWrapper> {
    
    func fetchData<M :Decodable>(target: T,responseClass : M.Type, completion:@escaping (Result<Data?, Error>) -> Void){
        let endpoint = target.endpoint ?? ""
        guard let url = URL(string: target.baseURL + endpoint) else{
            print("error in url")
            return
        }
        
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = target.httpMethod.rawValue
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request){ [weak self] (data,response,error) in
            guard let _ = self else { return }
            guard let response = response as? HTTPURLResponse else {
                return
                
            }
            if let error = error{
                completion(.failure(error))
            }

            
            
            if response.statusCode == 200{
                print("success \(String(describing: data))")
                completion(.success(data))
            }else {
                completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: nil)))
            }

            
        }.resume()
    }
}
