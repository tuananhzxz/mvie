//
//  Extension.swift
//  MovieClone
//
//  Created by tuananhdo on 5/1/25.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
