//
//  ListNewsUsecase.swift
//  KNews
//
//  Created by Amin on 15/08/2021.
//

import Foundation


protocol ListNewsUCType {
    func fetchNews(pagination: Bool,completion: @escaping (Result<[NewsItem], Error>) -> Void)
}
class ListNewsUsecase : ListNewsUCType{
    private var repo : NewsRepoType!
    static var page = 1
    
    init(repo : NewsRepoType) {
        self.repo = repo
    }
    
    func fetchNews(pagination: Bool,completion: @escaping (Result<[NewsItem], Error>) -> Void){
        ListNewsUsecase.page = pagination ? ListNewsUsecase.page + 1 : ListNewsUsecase.page
        
        
        print("+++++++++",ListNewsUsecase.page)
        guard ListNewsUsecase.page <= 5 else {
            ListNewsUsecase.page  =  ListNewsUsecase.page - 1
            completion(.success([]))
            return
        }
        repo.fetchNews(page: ListNewsUsecase.page, fromDate: getCurrentDate(), toDate: getDesiredDate()) { [weak self](result) in
            guard let self = self else { return }

            switch result{
            case .success(let data):
                var articles = self.getResponseFromDataObject(data: data)
                self.unifyDate(for:&articles)
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
    
    private func unifyDate(for items: inout [NewsItem]){
        for index in items.indices{
            items[index].publishedAt = items[index].publishedAt?.toDate(WithFormate: .d_MMM_yyyy)
        }
    }
    
}

