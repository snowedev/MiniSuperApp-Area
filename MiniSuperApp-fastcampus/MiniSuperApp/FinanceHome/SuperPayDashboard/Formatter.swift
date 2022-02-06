//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/05.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
