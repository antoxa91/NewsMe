//
//  Extension + String.swift
//  NewsMe
//
//  Created by Антон Стафеев on 05.09.2022.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self,
                          tableName: "Localizable",
                          bundle: .main,
                          value: self,
                          comment: self)
    }
}
