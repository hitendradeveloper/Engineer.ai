//
//  PostDataModel.swift
//  EngineerAI
//
//  Created by Apple on 29/04/19.
//  Copyright © 2019 Hitendra iDev. All rights reserved.
//

import Foundation

class Post: Codable {
    var title: String = ""
    var author: String = ""
    var created_at: String = ""
}

//Make the model selectable
extension Post: HSSelectable { }


extension Post {
    var displableCreatedData: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:self.created_at)!
        
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm a"
        return dateFormatter.string(from: date)
    }
}
