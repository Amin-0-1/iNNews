//
//  FormatDate.swift
//  iNNNews
//
//  Created by Amin on 18/07/2021.
//

import Foundation

//private func getCurrentDate()->String{
//    let formate = DateFormatter()
//    formate.dateFormat = "yyyy-MM-dd"
//
//    let date = Date()
//
//    let formatted = formate.string(from: date)
//    return formatted
//
//}

enum DateFormats:String {
    /// eg Sunday, Jul 18, 2021
    case EEEE_MMM_d_yyyy = "EEEE, MMM d, yyyy"
    /// eg 07/18/2021
    case MM_dd_yyyy = "MM/dd/yyyy"
    /// eg 07-18-2021 11:22 am
    case MM_dd_yyyy_hh_mm = "MM-dd-yyyy hh:mm a"
    /// eg Jul 18, 2021
    case MMM_d_yyyy = "MMM d, yyyy"
    /// eg 18 Jul, 2021
    case d_MMM_yyyy = "d MMM, yyyy"
    /// eg 2021-07-18
    case yyyy_MM_dd = "yyyy-MM-dd"
}
class CustomDate {
    private var formate : DateFormatter!
    
    init(with formate:DateFormats) {
        self.formate = DateFormatter()
        self.formate.dateFormat = formate.rawValue
    }
    func getCurrentDate() -> String {
        let date = Date()
        let formatted = formate.string(from: date)
        return formatted
    }
    func getFormattedDateFromApi(with date:String) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // api iso format
        if let date = formatter.date(from: date){
            return formate.string(from: date)
        }
        return nil
    }
}

extension String{
    func toDate(WithFormate:DateFormats) -> String? {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: self) else {return nil}
        dateFormatter.dateFormat = "d MMM, yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
