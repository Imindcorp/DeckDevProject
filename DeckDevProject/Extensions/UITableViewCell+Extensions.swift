//
//  UITableViewCell+Extensions.swift
//  DeckDevProject
//
//  Created by Ilnur Mindubayev on 01.05.2023.
//

import UIKit

public extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
