//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/26.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
	func attachAddPaymentMethod(closeButtonType: DismissButtonType)
	func detachAddpaymentMethod()
	func attachEnterAmount()
	func detachEnterAmount()
	func attachCardOnFile(paymentMethods: [PaymentMethod])
	func detachCardOnFile()
	func popToRoot()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
	func topupDidFinish()
}

protocol TopupInteractorDependency {
	var cardOnFileRepository: CardOnFileRepository { get }
	var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AdaptivePresenttationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?
	
	let presentationDelegateProxy: AdaptivePresenttationControllerDelegateProxy
	
	private var isEnterAmountRoot: Bool = false
	
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
			isEnterAmountRoot = true
			dependency.paymentMethodStream.send(card)
			router?.attachEnterAmount()
		} else {
			// 카드 추가 화면
			isEnterAmountRoot = false
			router?.attachAddPaymentMethod(closeButtonType: .close)
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
		if isEnterAmountRoot == false {
			listener?.topupDidClose()
		}
	}
	
	func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
		dependency.paymentMethodStream.send(paymentMethod)
		
		if isEnterAmountRoot {
			router?.popToRoot()
		} else {
			isEnterAmountRoot = true
			router?.attachEnterAmount()
		}
	}
	
	// MARK: EnterAmountListener
	func enterAmountDidTapClose() {
		router?.detachEnterAmount()
		listener?.topupDidClose()
	}
	
	func enterAmountDidTapPaymentMethod() {
		router?.attachCardOnFile(paymentMethods: paymentMethods)
	}
	
	func enterAmountDidFinishTopup() {
		listener?.topupDidFinish()
	}
	
	// MARK: CardOnFileListener
	func cardOnFileDidTapClose() {
		router?.detachCardOnFile()
	}
	
	func cardOnFileDidTapAddCard() {
		router?.attachAddPaymentMethod(closeButtonType: .back)
	}
	
	func cardOnFileDidSelect(at index: Int) {
		if let selected = paymentMethods[safe: index] {
			dependency.paymentMethodStream.send(selected)
		}
		router?.detachCardOnFile()
	}
}
