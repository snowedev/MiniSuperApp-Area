//
//  AddPaymentMethodRoutingRouter.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/26.
//

import ModernRIBs

protocol AddPaymentMethodRoutingInteractable: Interactable {
    var router: AddPaymentMethodRoutingRouting? { get set }
    var listener: AddPaymentMethodRoutingListener? { get set }
}

protocol AddPaymentMethodRoutingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AddPaymentMethodRoutingRouter: ViewableRouter<AddPaymentMethodRoutingInteractable, AddPaymentMethodRoutingViewControllable>, AddPaymentMethodRoutingRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AddPaymentMethodRoutingInteractable, viewController: AddPaymentMethodRoutingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
