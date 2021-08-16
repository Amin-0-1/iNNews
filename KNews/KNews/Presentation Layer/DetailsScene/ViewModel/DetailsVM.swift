//
//  DetailsVM.swift
//  iNNNews
//
//  Created by Amin on 18/07/2021.
//

import Foundation

protocol DetailsSending {
    func getFormattedPublishedAtDate(date: String?)->String?
}
protocol DetailsReceving {}
protocol DetailsType: DetailsSending,DetailsReceving {}

class DetailsVM : DetailsType{
    
    func getFormattedPublishedAtDate(date: String?) -> String?{
        guard let date = date else { return nil}
        let customDate = CustomDate(with: .MMM_d_yyyy).getFormattedDateFromApi(with: date)
        return customDate
    }
    
    
}
