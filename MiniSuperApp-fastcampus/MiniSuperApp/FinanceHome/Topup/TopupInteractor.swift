//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/26.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
	func attachAddPaymentMethod()
	func detachAddpaymentMethod()
	func attachEnterAmount()
	func detachEnterAmount()
	func attachCardOnFile(paymentMethods: [PaymentMethod])
	func detachCardOnFile()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
}

protocol TopupInteractorDependency {
	var cardOnFileRepository: CardOnFileRepository { get }
	var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AdaptivePresenttationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?
	
	let presentationDelegateProxy: AdaptivePresenttationControllerDelegateProxy
	
	private var paymentMethods: [PaymentMethod] {
		dependency.cardOnFileRepository.cardOnFile.value
	}
	private let dependency: TopupInteractorDependency
	
	init(
		dependency: TopupInteractorDependency
	) {
		self.presentationDelegateProxy = AdaptivePresenttationControllerDelegateProxy()
		self.dependency = dependency
		super.init()
		self.presentationDelegateProxy.delegate = self
	}

    override func didBecomeActive() {
        super.didBecomeActive()
		
		if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
			// 금액 입력 화면
			dependency.paymentMethodStream.send(card)
			router?.attachEnterAmount()
		} else {
			// 카드 추가 화면
			router?.attachAddPaymentMethod()
		}
        
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
    }
	
	func presentationControllerDidDismiss() {
		listener?.topupDidClose()
	}
	
	// MARK: AddPaymentMethodListener
	func addPaymentMethodDidTapClose() {
		router?.detachAddpaymentMethod()
		listener?.topupDidClose()
	}
	
	func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
		
	}
	
	// MARK: EnterAmountListener
	func enterAmountDidTapClose() {
		router?.detachEnterAmount()
		listener?.topupDidClose()
	}
	
	func enterAmountDidTapPaymentMethod() {
		router?.attachCardOnFile(paymentMethods: paymentMethods)
	}
	
	// MARK: CardOnFileListener
	func cardOnFileDidTapClose() {
		router?.detachCardOnFile()
	}
	
	func cardOnFileDidTapAddCard() {
		// TODO: attach add card
	}
	
	func cardOnFileDidSelect(at index: Int) {
		if let selected = paymentMethods[safe: index] {
			dependency.paymentMethodStream.send(selected)
		}
		router?.detachCardOnFile()
	}
}
