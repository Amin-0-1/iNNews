//
//  ListNewsVM.swift
//  KNews
//
//  Created by Amin on 15/08/2021.
//

import Foundation
import RxCocoa
import RxSwift


protocol ListNewsType {
    
    var loading: Driver<Bool>{get}
    var showError: Driver<String>{get}
    var listNews: Driver<[NewsItem]>{get}
    
    func fetchNewsData()
    
}


class ListNewsVM : ListNewsType{
    var loading: Driver<Bool>
    var showError: Driver<String>
    var listNews: Driver<[NewsItem]>
    
    private var showErrorSubject = PublishSubject<String>()
    private var loadingSubject = PublishSubject<Bool>()
    private var listNewsSubject = PublishSubject<[NewsItem]>()
    
    private var listNewsUsecase: ListNewsUCType!
    
    init() {
        listNewsUsecase = ListNewsUsecase(repo: Repo(remote: Remotedatasource()))
        
        loading = loadingSubject.asObservable().asDriver(onErrorJustReturn: false)
        showError = showErrorSubject.asObservable().asDriver(onErrorJustReturn: "")
        listNews = listNewsSubject.asObservable().asDriver(onErrorJustReturn: [])
        
    }
    func fetchNewsData() {
        loadingSubject.onNext(true)
        listNewsUsecase.fetchNews(page: 1) {  [weak self] (result) in
            guard let self = self else { return }
            self.loadingSubject.onNext(false)
            
            switch result {
            case .failure(let error):
                self.showErrorSubject.onNext(error.localizedDescription)
            case .success(let news):
                self.listNewsSubject.onNext(news)
            }
            
        }
        
    }
    
    
}
