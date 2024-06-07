//
//
//
//
//import UIKit
//
//class MyPresentationController: UIPresentationController {
//    private var dimmingView: UIView!
//
//    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
//        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
//        setupDimmingView()
//    }
//
//    private func setupDimmingView() {
//        dimmingView = UIView()
//        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        dimmingView.alpha = 0.0
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        dimmingView.addGestureRecognizer(tapGesture)
//    }
//
//    @objc private func handleTap() {
//        presentingViewController.dismiss(animated: true, completion: nil)
//    }
//
//    override var frameOfPresentedViewInContainerView: CGRect {
//        guard let containerView = containerView else { return .zero }
//        let height = containerView.bounds.height * 0.2
//        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
//    }
//
//    override func presentationTransitionWillBegin() {
//        guard let containerView = containerView else { return }
//
//        dimmingView.frame = containerView.bounds
//        containerView.addSubview(dimmingView)
//        containerView.addSubview(presentedViewController.view)
//
//        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
//            self.dimmingView.alpha = 1.0
//        })
//    }
//
//    override func dismissalTransitionWillBegin() {
//        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
//            self.dimmingView.alpha = 0.0
//        }, completion: { _ in
//            self.dimmingView.removeFromSuperview()
//        })
//    }
//
//    override func containerViewWillLayoutSubviews() {
//        super.containerViewWillLayoutSubviews()
//        presentedViewController.view.frame = frameOfPresentedViewInContainerView
//    }
//}
