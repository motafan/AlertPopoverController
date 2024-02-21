//
//  ViewController.swift
//  AlertPopoverController
//
//  Created by 风起兮 on 2024/2/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = UIButton(type: .system)
        button.setTitle("Alert", for: .normal)
        button.addTarget(self, action: #selector(alert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    @objc func alert() {
        let vc = AlertPopoverController()
        vc.preferredContentSize =  CGSize(width: 300, height: 208)
        present(vc, animated: true)
    }

}



class AlertPopoverController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    ///是否可以点击背景消失
    public var enableDismiss = false
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupPopover()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupPopover(){
        //必须在弹窗弹出前设置modalPresentationStyle
        modalPresentationStyle = .popover
        popoverPresentationController?.permittedArrowDirections = .up
        popoverPresentationController?.delegate = self
        popoverPresentationController?.canOverlapSourceViewRect = true
        popoverPresentationController?.popoverBackgroundViewClass = AlertPopoverBackgroundView.self
    }
    
    override var preferredContentSize: CGSize {
        didSet {
            if !isViewLoaded {
                setupPopoverSource()
      
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        //防止使用storyboard后没有设置contentSize
        //子类要再super.viewDidLoad()之前设置size
        
        view.backgroundColor = .systemBackground
        
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "演示处理键盘"
        
        let textField2 = UITextField()
        textField2.borderStyle = .roundedRect
        textField2.placeholder = "横屏演示处理键盘"
        
        let exitButton  = UIButton(type: .system)
        exitButton.setTitle("Dismiss Keyboard", for: .normal)
        exitButton.setTitleColor(.red, for: .normal)
        exitButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        
        let stackView  = UIStackView(arrangedSubviews: [textField,textField2, exitButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        setupPopoverSource()

 
    }
    
    private func setupPopoverSource() {
        
        //从A控制器通过present的方式跳转到了B控制器，那么 A.presentedViewController 就是B控制器；B.presentingViewController 就是A控制器
        //不能在init中，因为presentingViewController在init中为nil
        weak var presentingView = presentingViewController?.view
        
        let screenSize = presentingView?.frame.size ?? UIScreen.main.bounds.size
        let sourceRect = CGRect(x:screenSize.width / 2, y: 0, width: 0, height:(screenSize.height - preferredContentSize.height)/2)
        popoverPresentationController?.sourceRect = sourceRect
        popoverPresentationController?.sourceView = presentingView
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK:UIPopoverPresentationControllerDelegate
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return enableDismiss
    }
    
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return enableDismiss
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
    
        let screenSize = view.pointee.frame.size
        let sourceRect = CGRect(x:screenSize.width / 2, y: 0, width: 0, height:(screenSize.height - preferredContentSize.height) / 2)
        rect.pointee = sourceRect
    }
    
}




//移除了箭头的弹窗背景
open class AlertPopoverBackgroundView : UIPopoverBackgroundView{
   
    
    public override static func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    public override static func arrowHeight() -> CGFloat {
        return 0
    }
    
    open override var arrowDirection: UIPopoverArrowDirection {
        get { return UIPopoverArrowDirection.up }
        set {setNeedsLayout()}
    }
    
    open override var arrowOffset: CGFloat {
        get { return 0 }
        set {setNeedsLayout()}
    }
    
}



