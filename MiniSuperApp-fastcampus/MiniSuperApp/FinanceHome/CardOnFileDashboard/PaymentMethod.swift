//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/05.
//

import Foundation
import UIKit

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
