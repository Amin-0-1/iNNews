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
    func searchNews(with query: String)
    func getCurrentNews()
    
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
    
    init(useCase: ListNewsUCType) {
        listNewsUsecase = useCase
        
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
                        self.listNewsSubject.onNext(news)
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
    
    func searchNews(with query: String) {
        listNewsUsecase.searchNews(with: query) { [weak self] (sectionModels) in
            guard let self = self else { return }
            self.listNewsSubject.onNext(sectionModels)
        }
    }
    
    func getCurrentNews() {
        listNewsUsecase.getCurrentNews { (sectionModels) in
            listNewsSubject.onNext(sectionModels)
        }
    }
    
    
    
    
}
