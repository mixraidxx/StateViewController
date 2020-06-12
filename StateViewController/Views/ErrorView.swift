//
//  ErrorView.swift
//  StateViewController
//
//  Created by Santiago Desarrollo on 11/06/20.
//  Copyright © 2020 Santiago Desarrollo. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    weak var delegate: ErrorViewDelegate?
    var animationDuration = 0.3
    fileprivate(set) var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Private methods
    private func configureView() {
        self.alpha = 0
    }
    
    fileprivate func show(animated: Bool = true, completion: ((Bool) -> Swift.Void)? = nil) {
        self.superview?.bringSubviewToFront(self)
        if animated {
            UIView.animate(withDuration: self.animationDuration, animations: { self.alpha = 1 }, completion: completion)
        } else {
            self.alpha = 1
            completion?(true)
        }
    }
    
    
    
}



protocol ErrorDisplayable {
    static func show<T: ErrorView>(
        fromViewController viewController: UIViewController,
        animated: Bool,
        completion: ((Bool) -> Swift.Void)?) -> T
    
    static func show<T: ErrorView>(
        fromView view: UIView,
        insets: UIEdgeInsets, animated: Bool,
        completion: ((Bool) -> Swift.Void)?) -> T
    
    func hide(animated: Bool, completion: ((Bool) -> Swift.Void)?)
}

protocol ErrorAnimatable {
    func playAnimation()
    func stopAnimation()
}
protocol ErrorViewDelegate: class {
    func errorView(_ errorView: ErrorView, didRetry sender: UIButton)
}


// MARK: - ErrorDisplayable
extension ErrorView: ErrorDisplayable {

  static func show<T: ErrorView>(
    fromViewController viewController: UIViewController,
    animated: Bool = true,
    completion: ((Bool) -> Swift.Void)? = nil) -> T {

   /* guard let subview = loadFromNib() as? T else {
      fatalError("The subview is expected to be of type \(T.self)")
    }*/

    viewController.view.addSubview(subview)

    // Configure constraints if needed
    
    subview.alpha = 0
    subview.superview?.sendSubview(toBack: subview)
    subview.show(animated: animated) { finished in
      if finished {
        subview.playAnimation()
      }
    }
    return subview
  }

  static func show<T: ErrorView>(
    fromView view: UIView,
    insets: UIEdgeInsets = UIEdgeInsets.zero,
    animated: Bool = true,
    completion: ((Bool) -> Swift.Void)? = nil) -> T {

    guard let subview = loadFromNib() as? T else {
      fatalError("The subview is expected to be of type \(T.self)")
    }
   
    view.addSubview(subview)
    
    // Configure constraints if needed
    
    subview.alpha = 0
    subview.superview?.sendSubview(toBack: subview)
    subview.show(animated: animated) { finished in
      if finished {
        subview.playAnimation()
      }
    }
    return subview
  }

  func hide(animated: Bool = true, completion: ((Bool) -> Swift.Void)? = nil) {
    self.stopAnimation()
    let closure: (Bool) -> Void = { (finished) in
      if finished {
        self.removeFromSuperview()
      }
    }
    if animated {
      UIView.animate(withDuration: self.animationDuration,
                     delay: 0.25,
                     animations: { self.alpha = 0 }, completion: { (finished) in
                      closure(finished)
                      completion?(finished)
      })
    } else {
      self.alpha = 0
      closure(true)
      completion?(true)
    }
  }
}
