//
//  DateFormatter.swift
//  app
//
//  Created by MAC on 3/28/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import Foundation

func formatDate(str: Any)-> String {
    
    //"Thu, 22 Oct 2015 07:45:17 +0000"
    
    if str is String{
        var dateString = str as! String
        let dateFormatter = DateFormatter()
        
        var pattern = ""
        if dateString.count == 25{
            pattern = "y-MM-dd HH:mm:ss +zzzz"
        }else if dateString == "" {
            return ""
        }
        else if(dateString.count == 31) {
            pattern = "EEE, dd MMM yyyy hh:mm:ss +zzzz" //"E MMM dd yyyy HH:mm:ss Z"
            
        }else if dateString.count == 24 {
            //"2017-10-04T11:54:46.853Z"
            let index = dateString.index(dateString.startIndex, offsetBy: 9)
            dateString = String(dateString[...index])
            pattern = "yyyy-MM-dd"
        }else{
            let index = dateString.index(dateString.startIndex, offsetBy: 24)
            dateString = String(dateString[...index])
            pattern = "EEE MMM dd yyyy HH:mm:ss"
        }
        
        dateFormatter.dateFormat = pattern
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter.string(from: dateObj!)
    }
    return "bad date"
}
