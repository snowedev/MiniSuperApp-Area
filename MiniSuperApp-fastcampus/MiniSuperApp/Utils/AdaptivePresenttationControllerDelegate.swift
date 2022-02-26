//
//  AdaptivePresenttationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/26.
//

import UIKit

protocol AdaptivePresenttationControllerDelegate: AnyObject {
	func presentationControllerDidDismiss()
}

final class AdaptivePresenttationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
	weak var delegate: AdaptivePresenttationControllerDelegate?
	
	func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		delegate?.presentationControllerDidDismiss()
	}
}
