//
//  Repo.swift
//  KNews
//
//  Created by Amin on 15/08/2021.
//

import Foundation

class Repo: NewsRepoType {
    let remote: RemotedatasourceType!
    
    init(remote:RemotedatasourceType) {
        self.remote = remote
    }
    func fetchNews(page: Int, fromDate: String, toDate: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        remote.fetchNews(page: page, fromDate: fromDate, toDate: toDate) { (result) in
            switch result{
            case .failure(let error):
                completion(.failure(error))
            case .success(let date):
                completion(.success(date))
            }
        }
    }
    
}
