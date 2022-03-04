//
//  EnterAmountBuilder.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/26.
//

import ModernRIBs

protocol EnterAmountDependency: Dependency {
	var selectedPaymentMethods: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
	var superPayRepository: SuperPayRespository { get }
}

final class EnterAmountComponent: Component<EnterAmountDependency>, EnterAmountInteractorDependency {
	var selectedPaymentMethods: ReadOnlyCurrentValuePublisher<PaymentMethod> { dependency.selectedPaymentMethods }
	var superPayRepository: SuperPayRespository { dependency.superPayRepository }
}

// MARK: - Builder

protocol EnterAmountBuildable: Buildable {
    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting
}

final class EnterAmountBuilder: Builder<EnterAmountDependency>, EnterAmountBuildable {

    override init(dependency: EnterAmountDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
        let component = EnterAmountComponent(dependency: dependency)
        let viewController = EnterAmountViewController()
        let interactor = EnterAmountInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return EnterAmountRouter(interactor: interactor, viewController: viewController)
    }
}
