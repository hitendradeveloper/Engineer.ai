//
//  AlgoliaDataModel.swift
//  EngineerAI
//
//  Created by Apple on 29/04/19.
//  Copyright © 2019 Hitendra iDev. All rights reserved.
//

import Foundation

class Algolia: Codable {
    var hits: [Post] = []
    var page: Int = 0
    var nbPages: Int = 0
}
