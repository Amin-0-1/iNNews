//
//  ListNewsUsecase.swift
//  KNews
//
//  Created by Amin on 15/08/2021.
//

import Foundation


protocol ListNewsUCType {
    func fetchNews(pagination: Bool,completion: @escaping (Result<[SectionModel], Error>) -> Void)
    func searchNews(with query:String ,completion:([SectionModel])->Void)
    func getCurrentNews(completion:([SectionModel])->Void)
}


class ListNewsUsecase : ListNewsUCType{
    
    
    private var repo : NewsRepoType!
    private var listOfSectionModels = [SectionModel]()

    static var page = 1
    
    
    init(repo : NewsRepoType) {
        self.repo = repo
    }
    
    func fetchNews(pagination: Bool,completion: @escaping (Result<[SectionModel], Error>) -> Void){
        ListNewsUsecase.page = pagination ? ListNewsUsecase.page + 1 : ListNewsUsecase.page
        
        
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
                let categorized = self.categorizeByDate(items: &articles)
                self.listOfSectionModels.append(contentsOf: categorized)
                completion(.success(self.listOfSectionModels))
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
    
    private func categorizeByDate(items: inout [NewsItem]) -> [SectionModel]{
        var sectiondData = [SectionModel]()
        
        let dates = Set(items.compactMap{ news in
            news.publishedAt
        })
        
        dates.forEach { (date) in
            let items = items.filter { (new) -> Bool in
                new.publishedAt == date
            }
            sectiondData.append(SectionModel(header: date, items: items))
        }
        return sectiondData
        
    }
    
    func getCurrentNews(completion: ([SectionModel]) -> Void) {
        completion(listOfSectionModels)
    }
    
    func searchNews(with query:String ,completion:([SectionModel])->Void) {
        var found = Set<NewsItem>()
        
        let allNews = listOfSectionModels.flatMap {
            return $0.items
        }
        
        allNews.filter{
            guard let source = $0.source?.name else { return false}
            return source.contains(query)

        }.forEach{ item in found.insert(item)}
        
        
        allNews.filter{
            guard let title = $0.title else { return false}
            return title.contains(query)
        }.forEach{ item in found.insert(item)}
        
        allNews.filter{
            guard let desc = $0.description else { return false }
            return desc.contains(query)
        }.forEach{ item in found.insert(item)}
        
        allNews.filter{
            guard let url = $0.url else { return false }
            return url.contains(query)
        }.forEach{ item in found.insert(item)}
        
        var data = Array(found)
        
        completion(categorizeByDate(items: &data))
    }
    
}

