//
//  HSIDentifiable.swift
//  HSFramework
//
//  Created by Hitendra Solanki on 10/05/18.
//  Copyright © 2018 Hitendra iDev. All rights reserved.
//

import Foundation

protocol HSIDentifiable {
    static var identifier: String { get }
    var identifier: String { get }
}

extension HSIDentifiable {
    static var identifier: String {
        return String(describing: self)
    }
    var identifier: String {
        return String(describing: self)
    }
}
