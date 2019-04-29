//
//  UITableView+HSDequeue.swift
//  HSFramework
//
//  Created by Hitendra Solanki on 10/05/18.
//  Copyright © 2018 Hitendra iDev. All rights reserved.
//

import Foundation
import UIKit

protocol HSTableViewCellReuseIdentifiable: HSIDentifiable { }
extension UITableViewCell : HSTableViewCellReuseIdentifiable { }

extension UITableView {
   
    // MARK: - UITableViewCell Instantiation from Generics
    func dequequeCell<T: UITableViewCell>(identifier: String = T.identifier) -> T {
        return self.dequequeCell(identifier: identifier, for: nil)
    }
    
    func dequequeCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        return self.dequequeCell(identifier: T.identifier, for: indexPath)
    }
    
    
    func dequequeCell<T: UITableViewCell>(identifier: String, for indexPath: IndexPath?) -> T {
        guard let path = indexPath else {
            guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
                fatalError(self.execFailureMessage(identifier: identifier)) //notifiy crash
            }
            return cell
        }
        
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: path)  as? T else {
            fatalError(self.execFailureMessage(identifier: identifier)) //notifiy crash
        }
        return cell
    }
    
    func execFailureMessage(identifier: String) -> String {
        return "HS: Couldn't instantiate \(self) with identifier \(identifier), reuse-identifier of your cell must be same as your class name (check your storyboard or xib for reuse-identifier or check the reuse-identifier you register using [class or nib])"
    }
}


