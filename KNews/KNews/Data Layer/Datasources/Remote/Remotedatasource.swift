//
//  Remotedatasource.swift
//  iNNNews
//
//  Created by Amin on 15/07/2021.
//

import Foundation

protocol RemotedatasourceType {

    func fetchNews(page: Int, fromDate: String, toDate: String, completion: @escaping (Result<Data?, Error>) -> Void)
    
}

class Remotedatasource: ApiServices<RemoteDataSourceWrapper> , RemotedatasourceType {
    
    func fetchNews(page: Int, fromDate: String, toDate: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        self.fetchData(target: .AllNews(page: page, start: fromDate, end: toDate), responseClass: AllNewsResponse.self) { (result) in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            case .success(let news):
            completion(.success(news))
            }
        }
    }

}
