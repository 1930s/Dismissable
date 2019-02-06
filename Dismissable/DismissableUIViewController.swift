//
//  DismissableUIViewController.swift
//  Dismissable
//
//  Created by Seungyoun Yi on 06/02/2019.
//  Copyright © 2019 Seungyoun Yi. All rights reserved.
//

import UIKit

open class DismissableUIViewController: UIViewController {
    public var interactor: DismissInteractor? = nil
    public var percentThreshold: CGFloat = 0.3

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(pangestureClicked))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func pangestureClicked(_ sender: UIPanGestureRecognizer) {
        let verticalMovement = Float(sender.translation(in: view).y / view.bounds.height)
        let progress = CGFloat(fminf(fmaxf(verticalMovement, 0.0), 1.0))
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
}

extension DismissableUIViewController: UIGestureRecognizerDelegate {
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
