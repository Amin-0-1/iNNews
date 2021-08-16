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
    
    func fetchNewsData()
    
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
    init() {
        listNewsUsecase = ListNewsUsecase(repo: Repo(remote: Remotedatasource()))
        
        loading = loadingSubject.asObservable().asDriver(onErrorJustReturn: true)
        showError = showErrorSubject.asObservable().asDriver(onErrorJustReturn: "")
        listNews = listNewsSubject.asObservable().asDriver(onErrorJustReturn: [])
        
        monitor = NWPathMonitor()
        
    }
    func fetchNewsData() {
        monitor.pathUpdateHandler = { [weak self] handler in
            
            guard let self = self else { return }
            self.loadingSubject.onNext(true)

            if handler.status == .satisfied {
                
                self.listNewsUsecase.fetchNews(page: 1) {  [weak self] (result) in
                    guard let self = self else { return }
                    self.loadingSubject.onNext(false)
                    
                    switch result {
                    case .failure(let error):
                        self.showErrorSubject.onNext(error.localizedDescription)
                        self.listNewsSubject.onNext([])
                    case .success(let news):
                        var sectiondData = [SectionModel]()
                        
                        let dates = Set(news.compactMap{ news in
                            news.publishedAt
                        })
                        
                        print("+++++++++++++",dates.count)
                        dates.forEach { (date) in
                            let items = news.filter { (new) -> Bool in
                                new.publishedAt == date
                            }
                            sectiondData.append(SectionModel(header: date, items: items))
                        }
                        print("+++++++++++++",sectiondData.count)
                        
                        
                        self.listNewsSubject.onNext(sectiondData)
                    }
                    
                }
            }else{
                self.loadingSubject.onNext(false)
                self.showErrorSubject.onNext("No Intenet Connection!!")
                self.listNewsSubject.onNext([])
                
            }
            
        }
        monitor.start(queue: DispatchQueue(label: "monitor"))
        
        
    }
    
    
}
