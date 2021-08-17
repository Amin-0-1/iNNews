//
//  FakeRepo.swift
//  KNewsTests
//
//  Created by Amin on 17/08/2021.
//

import Foundation
@testable import KNews

class FakeRepo: NewsRepoType {
    private var shouldReturnError:Bool!
    init(shouldReturnError:Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    func fetchNews(page: Int, fromDate: String, toDate: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        shouldReturnError ? completion(.failure(NSError(domain: "Error", code: 404, userInfo: nil))) : completion(.success(loadJson()))
    }
    
    func loadJson() -> Data? {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "response", ofType: "json") else {
            fatalError("UnitTestData.json not found")
        }
        
        guard let stringContent = try? String(contentsOfFile: pathString) else {
            return nil
            
        }
        
        print("+++++++++++",stringContent)
        return stringContent.data(using: .unicode)
        
    }
}
