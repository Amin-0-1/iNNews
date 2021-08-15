//
//  NewsRepository.swift
//  iNNNews
//
//  Created by Amin on 15/07/2021.
//

import Foundation

protocol NewsRepoType{
    func fetchNews(page:Int,fromDate:String,toDate:String,completion: @escaping (Result<Data?,Error>)->Void)
}
