//
//  AddPaymentMethodRoutingBuilder.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/26.
//

import ModernRIBs

protocol AddPaymentMethodRoutingDependency: Dependency {
	var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodRoutingComponent: Component<AddPaymentMethodRoutingDependency>, AddPaymentMethodInteractorDependency {
	var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AddPaymentMethodRoutingBuildable: Buildable {
    func build(withListener listener: AddPaymentMethodRoutingListener) -> AddPaymentMethodRoutingRouting
}

final class AddPaymentMethodRoutingBuilder: Builder<AddPaymentMethodRoutingDependency>, AddPaymentMethodRoutingBuildable {

    override init(dependency: AddPaymentMethodRoutingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddPaymentMethodRoutingListener) -> AddPaymentMethodRoutingRouting {
        let component = AddPaymentMethodRoutingComponent(dependency: dependency)
        let viewController = AddPaymentMethodRoutingViewController()
        let interactor = AddPaymentMethodRoutingInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return AddPaymentMethodRoutingRouter(interactor: interactor, viewController: viewController)
    }
}
