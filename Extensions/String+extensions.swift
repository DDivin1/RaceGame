//
//  String+extensions.swift
//  RaceGame
//
//  Created by Dmitry Divin on 6.03.26.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
