//
//  SectionModel.swift
//  KNews
//
//  Created by Amin on 16/08/2021.
//

import Foundation
import RxDataSources

struct SectionModel {
    var header: String
    var items: [NewsItem]
}

extension SectionModel : SectionModelType{
    init(original: SectionModel, items: [NewsItem]) {
        self = original
        self.items = items
    }
    
    
}
