//
//  ListNewsUsecase.swift
//  KNews
//
//  Created by Amin on 15/08/2021.
//

import Foundation


protocol ListNewsUCType {
    func fetchNews(page: Int,completion: @escaping (Result<[NewsItem], Error>) -> Void)
}
class ListNewsUsecase : ListNewsUCType{
    private var repo : NewsRepoType!

    init(repo : NewsRepoType) {
        self.repo = repo
    }
    func fetchNews(page: Int,completion: @escaping (Result<[NewsItem], Error>) -> Void){
        repo.fetchNews(page: page, fromDate: getCurrentDate(), toDate: getDesiredDate()) { [weak self](result) in
            guard let self = self else { return }

            switch result{
            case .success(let data):
                let articles = self.getResponseFromDataObject(data: data)
                completion(.success(articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getCurrentDate()->String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString = df.string(from: date)
        return dateString
    }
    private func getDesiredDate()->String{
        let date = Date()
        guard let oneMonthBackDate = Calendar.current.date(byAdding: .month, value: -1, to: date) else { return "" }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString = df.string(from: oneMonthBackDate)
        return dateString
    }
    
    private func getResponseFromDataObject(data:Data?)->[NewsItem]{
        guard let data = data else { return []}
        
        guard let response = try? JSONDecoder().decode(AllNewsResponse.self, from: data) else {
            return []
            
        }
        return response.articles
    }
    
}
