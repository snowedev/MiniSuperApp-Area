//
//  AddPaymentMethodRoutingInteractor.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/26.
//

import ModernRIBs
import Combine

protocol AddPaymentMethodRoutingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddPaymentMethodRoutingPresentable: Presentable {
    var listener: AddPaymentMethodRoutingPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AddPaymentMethodRoutingListener: AnyObject {
    func addPaymentMethodDidTapClose()
	func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod)
}

protocol AddPaymentMethodInteractorDependency {
	var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodRoutingInteractor: PresentableInteractor<AddPaymentMethodRoutingPresentable>, AddPaymentMethodRoutingInteractable, AddPaymentMethodRoutingPresentableListener {

    weak var router: AddPaymentMethodRoutingRouting?
    weak var listener: AddPaymentMethodRoutingListener?

	private let dependency: AddPaymentMethodInteractorDependency
	private var cancellables: Set<AnyCancellable>

	init(
		presenter: AddPaymentMethodRoutingPresentable,
		dependency: AddPaymentMethodInteractorDependency
	) {
		self.dependency = dependency
		self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
	
	func didTapClose() {
		listener?.addPaymentMethodDidTapClose()
	}
	
	func didTapConfirm(with number: String, cvc: String, expiry: String) {
		let info = AddPaymentMethodInfo(number: number, cvc: cvc, expiry: expiry)
		dependency.cardOnFileRepository.addCard(info: info).sink(
			receiveCompletion: { _ in},
			receiveValue: { [weak self] method in
				self?.listener?.addPaymentMethodDidAddCard(paymentMethod: method)
			}
		).store(in: &cancellables)
	}
}
