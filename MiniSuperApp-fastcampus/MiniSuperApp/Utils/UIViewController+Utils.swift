//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by Wonseok Lee on 2022/02/26.
//

import UIKit

enum DismissButtonType {
	case back, close
	
	var iconSystemName: String {
		switch self {
		case .back:
			return "chevron.backward"
		case .close:
			return "xmark"
		}
	}
}
extension UIViewController {
	func setupNavigationItem(with buttonType: DismissButtonType, target: Any?, action: Selector?) {
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage.init(
				systemName: buttonType.iconSystemName,
				withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
			),
			style: .plain,
			target: target,
			action: action
		)
	}
}
