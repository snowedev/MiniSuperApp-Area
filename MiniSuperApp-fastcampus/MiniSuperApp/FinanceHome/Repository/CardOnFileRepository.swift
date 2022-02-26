//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/06.
//

import Foundation
import Combine

// 서버 API를 호출해서 카드 목록을 가져온다.
protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
	func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodSubject }
    
    private let paymentMethodSubject = CurrentValuePublisher<[PaymentMethod]>([
        PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
        PaymentMethod(id: "1", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
    ])
	
	func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
		let paymentMethod = PaymentMethod(id: "00", name: "New 카드", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)
		
		var new = paymentMethodSubject.value
		new.append(paymentMethod)
		paymentMethodSubject.send(new)
		
		return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
	}
}
