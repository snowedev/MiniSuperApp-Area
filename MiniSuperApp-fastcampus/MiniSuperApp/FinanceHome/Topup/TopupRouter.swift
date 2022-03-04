//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/26.
//

import ModernRIBs

protocol TopupInteractable: Interactable,
							AddPaymentMethodListener,
							EnterAmountListener,
							CardOnFileListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
	var presentationDelegateProxy: AdaptivePresenttationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
	
	private var naviagtionControllable: NavigationControllerable?
	private let viewController: ViewControllable
	
	private let addPaymentMethodBuildable: AddPaymentMethodBuildable
	private var addPaymentMethodRouting: Routing?
	
	private let enterAmountBuildable: EnterAmountBuildable
	private var enterAmountRouting: Routing?
	
	private let cardOnFileBuildable: CardOnFileBuildable
	private var cardOnFileRouting: Routing?
	
    init(
		interactor: TopupInteractable,
		viewController: ViewControllable,
		addPaymentMethodBuildable: AddPaymentMethodBuildable,
		enterAmountBuildable: EnterAmountBuildable,
		cardOnFileBuildable: CardOnFileBuildable
	) {
        self.viewController = viewController
		self.addPaymentMethodBuildable = addPaymentMethodBuildable
		self.enterAmountBuildable = enterAmountBuildable
		self.cardOnFileBuildable = cardOnFileBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
		if viewController.uiviewController.presentedViewController != nil,
		   naviagtionControllable != nil {
			naviagtionControllable?.dismiss(completion: nil)
		}
    }

	func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
		if addPaymentMethodRouting != nil { return }
		
		let router = addPaymentMethodBuildable.build(withListener: interactor,  closeButtonType: closeButtonType)
		
		if let naviagtionControllable = naviagtionControllable {
			naviagtionControllable.pushViewController(router.viewControllable, animated: true)
		} else {
			presentInsideNavigation(router.viewControllable)
		}
		attachChild(router)
		addPaymentMethodRouting = router
	}
	
	func detachAddpaymentMethod() {
		guard let router = addPaymentMethodRouting else { return }
		
		naviagtionControllable?.popViewController(animated: true)
		detachChild(router)
		addPaymentMethodRouting = nil
	}
	
	func attachEnterAmount() {
		if enterAmountRouting != nil { return }
		
		let router = enterAmountBuildable.build(withListener: interactor)
		
		if let naviagtionControllable = naviagtionControllable {
			naviagtionControllable.setViewControllers([router.viewControllable])
			resetChildRouting()
		} else {
			presentInsideNavigation(router.viewControllable)
		}
		enterAmountRouting = router
		attachChild(router)
	}
	
	func detachEnterAmount() {
		guard let enterAmountRouting = enterAmountRouting else {
			return
		}
		dismissPresentNavigation(completion: nil)
		detachChild(enterAmountRouting)
		self.enterAmountRouting = nil
	}
	
	func attachCardOnFile(paymentMethods: [PaymentMethod]) {
		if cardOnFileRouting != nil { return }
		let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
		naviagtionControllable?.pushViewController(router.viewControllable, animated: true)
		cardOnFileRouting = router
		attachChild(router)
	}
	
	func detachCardOnFile() {
		guard let cardOnFileRouting = cardOnFileRouting else {
			return
		}
		naviagtionControllable?.popViewController(animated: true)
		self.cardOnFileRouting = nil
		detachChild(cardOnFileRouting)
	}
	
	func popToRoot() {
		naviagtionControllable?.popToRoot(animated: true)
		resetChildRouting()
	}
	
	// MARK: Private
	
	private func presentInsideNavigation(_ viewControllable: ViewControllable) {
		let navigation = NavigationControllerable(root: viewControllable)
		navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
		self.naviagtionControllable = navigation
		viewController.present(navigation, animated: true, completion: nil)
	}
	
	private func dismissPresentNavigation(completion: (() -> Void)?) {
		if self.naviagtionControllable == nil { return }
		viewController.dismiss(completion: nil)
		self.naviagtionControllable = nil
	}
	
	private func resetChildRouting() {
		if let cardOnFileRouting = cardOnFileRouting {
			detachChild(cardOnFileRouting)
			self.cardOnFileRouting = nil
		}
		
		if let addPaymentMethodRouting = addPaymentMethodRouting {
			detachChild(addPaymentMethodRouting)
			self.addPaymentMethodRouting = nil
		}
	}
}
