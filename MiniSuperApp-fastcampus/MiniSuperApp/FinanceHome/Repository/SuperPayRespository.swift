//
//  SuperPayRespository.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/27.
//

import Foundation
import Combine

protocol SuperPayRespository {
	var balance: ReadOnlyCurrentValuePublisher<Double> { get }
	func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
}

final class SuperPayRespositoryImp: SuperPayRespository {
	var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
	private let balanceSubject = CurrentValuePublisher<Double>(0)
	
	// 실제 API 호출을 안하는대신 일부러 delay를 줘서 흉내낸 API 호출 코드
	func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
		return Future<Void, Error> { [weak self] promise in
			self?.bgQueue.async {
				Thread.sleep(forTimeInterval: 2)
				promise(.success(()))
				let newBalance = (self?.balanceSubject.value).map { $0 + amount }
				newBalance.map { self?.balanceSubject.send($0) }
			}
		}.eraseToAnyPublisher()
	}
	
	private let bgQueue = DispatchQueue(label: "topup.respository.queue")
}

