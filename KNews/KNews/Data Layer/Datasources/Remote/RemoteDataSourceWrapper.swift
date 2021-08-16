//
//  RemoteDataSourceWrapper.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 20/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation



enum RemoteDataSourceWrapper{
    case AllNews(page:Int,start:String,end:String)
    
}

extension RemoteDataSourceWrapper :ApiRequestWrapper{
    
    var httpMethod: HttpMethod {
        
        switch self {
        case .AllNews:
            return .get
        }
    }
    
    var httpBody:Data?{
        switch self {
        default:
            return nil
        }
    }
    
   
    var baseURL: String {
        switch self {
        case .AllNews(let page,let start,let end):
            
            return "https://newsapi.org/v2/everything?q=technology&from=\(start)&to=\(end)&apiKey=\(Const.APIKEY)&page=\(page)&sortBy=publishedAt"
            
        }
        
    }
    
    var endpoint: String? {
        switch self {

        default:
            return nil
        }

    }
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
    
    
}
