//
//  ListNewsVM.swift
//  KNews
//
//  Created by Amin on 15/08/2021.
//

import Foundation
import RxCocoa
import RxSwift
import Network


protocol ListNewsType {
    
    var loading: Driver<Bool>{get}
    var showError: Driver<String>{get}
    var listNews: Driver<[SectionModel]>{get}
    
    func fetchNewsData(pagination:Bool)
    
}


class ListNewsVM : ListNewsType{
    var loading: Driver<Bool>
    var showError: Driver<String>
    var listNews: Driver<[SectionModel]>
    
    private var showErrorSubject = PublishSubject<String>()
    private var loadingSubject = PublishSubject<Bool>()
    private var listNewsSubject = PublishSubject<[SectionModel]>()
    
    private var listNewsUsecase: ListNewsUCType!
    private let monitor : NWPathMonitor!
    private var listOfNews = [NewsItem]()
    
    init() {
        listNewsUsecase = ListNewsUsecase(repo: Repo(remote: Remotedatasource()))
        
        loading = loadingSubject.asObservable().asDriver(onErrorJustReturn: true)
        showError = showErrorSubject.asObservable().asDriver(onErrorJustReturn: "")
        listNews = listNewsSubject.asObservable().asDriver(onErrorJustReturn: [])
        
        monitor = NWPathMonitor()
        
    }

    func fetchNewsData(pagination:Bool) {
        monitor.pathUpdateHandler = { [weak self] handler in
            
            guard let self = self else { return }
            pagination ? nil : self.loadingSubject.onNext(true)

            if handler.status == .satisfied {
                
                self.listNewsUsecase.fetchNews(pagination: pagination) {  [weak self] (result) in
                    guard let self = self else { return }
                    pagination ? nil : self.loadingSubject.onNext(false)

                    switch result {
                    case .failure(let error):
                        self.showErrorSubject.onNext(error.localizedDescription)
                        self.listNewsSubject.onNext([])
                    case .success(let news):
                        
                        guard !news.isEmpty else {
                            self.showErrorSubject.onNext("No Further News!!")
                            return
                        }
                        self.listOfNews.append(contentsOf: news)
                        
                        var sectiondData = [SectionModel]()
                        
                        let dates = Set(self.listOfNews.compactMap{ news in
                            news.publishedAt
                        })
                        
                        dates.forEach { (date) in
                            let items = self.listOfNews.filter { (new) -> Bool in
                                new.publishedAt == date
                            }
                            sectiondData.append(SectionModel(header: date, items: items))
                        }
                        self.listNewsSubject.onNext(sectiondData)
                    }
                    
                }
            }else{
                ListNewsUsecase.page = 1
                pagination ? nil : self.loadingSubject.onNext(false)
                self.showErrorSubject.onNext("No Intenet Connection!!")
                self.listNewsSubject.onNext([])
                
            }
            
        }
        monitor.start(queue: DispatchQueue(label: "monitor"))
        
        
    }
    
    
}
