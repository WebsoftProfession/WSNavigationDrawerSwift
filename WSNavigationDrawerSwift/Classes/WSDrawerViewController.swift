//
//  WSDrawerViewController.swift
//  WSNavigationDrawerSwift
//
//  Created by WebsoftProfession on 04/17/2023.
//  Copyright (c) 2023 WebsoftProfession. All rights reserved.
//

import UIKit

public enum WSDrawerDirection {
    case left
    case right
}

public enum WSDrawerMode {
    case left
    case right
    case all
}

enum WSDrawerDragState {
    case leftOpen
    case leftClose
    case rightOpen
    case rightClose
}


public class WSDrawerViewController: UIViewController {
    
    public var leftViewController: UIViewController?
    public var rightViewController: UIViewController?
    public var homeViewController: UIViewController?
    
    static let shared = WSDrawerViewController()
    
    // public properties
    public var drawerWidth: CGFloat = 0.0
    public var isPanEnabled: Bool = true
    
    public var drawerShadowColor: UIColor = .black {
        didSet {
            WSDrawerViewController.shared.homeViewController?.view.layer.shadowColor = self.drawerShadowColor.cgColor
        }
    }
    public var drawerMode:WSDrawerMode = .all
    
    var isRightView: Bool = false
    
    // internal properties
    var touchStartPoint: CGPoint = .zero
    var touchEndPoint: CGPoint = .zero
    var touchHoldPoint: CGPoint = .zero
    var isClosing: Bool = false
        
    var viewStartDragPoint:CGFloat = 0.0
    var currentDragState:WSDrawerDragState = .leftOpen
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isRightView = self.rightViewController != nil
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureDrawer()
    }
    
    func configureDrawer(){
        
        self.homeViewController?.view.layer.masksToBounds = false
        self.homeViewController?.view.layer.shadowColor = self.drawerShadowColor.cgColor
        self.homeViewController?.view.layer.shadowOpacity = 0.3
        self.homeViewController?.view.layer.shadowOffset = .zero
        self.homeViewController?.view.layer.shadowRadius = 2
        self.homeViewController?.view.layer.shouldRasterize = true
        self.homeViewController?.view.layer.rasterizationScale = 1
        
        if (self.leftViewController != nil) {
            self.configureController(controller: self.leftViewController!)
            WSDrawerViewController.shared.leftViewController = self.leftViewController!
        }
        else {
//            assertionFailure("Please set left view controller")
        }
        
        if (self.rightViewController != nil) {
            self.configureController(controller: self.rightViewController!)
            WSDrawerViewController.shared.rightViewController = self.rightViewController!
        }
        
        if (self.homeViewController != nil) {
            self.configureController(controller: self.homeViewController!)
            WSDrawerViewController.shared.homeViewController = self.homeViewController!
            if (self.drawerWidth==0) {
                self.configureDrawerWidth()
            }
            
            WSDrawerViewController.shared.drawerWidth = self.drawerWidth
            
            let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(pan:)))
            WSDrawerViewController.shared.homeViewController?.view.addGestureRecognizer(panGesture)
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(tap:)))
            WSDrawerViewController.shared.homeViewController?.view.addGestureRecognizer(tapGesture)
        }
        else{
            assertionFailure("Please set home view controller")
        }
    }
    
    
    
    public func toggleDrawer(mode: WSDrawerDirection) {
        
        var drawerRatio:CGFloat = 0
        var touchEnable = false
        
        var isDrawerOpen = self.drawer.homeViewController!.view.frame.origin.x == self.drawerWidth
        
        if mode == .right {
            isDrawerOpen = self.drawer.homeViewController!.view.frame.origin.x == (-self.drawerWidth)
        }
        
        if (mode == .left && self.leftViewController != nil) {
            if (!isDrawerOpen && self.drawer.leftViewController!.responds(to: #selector(self.viewWillAppear(_:)))) {
                self.drawer.leftViewController?.viewWillAppear(true)
            }
            
            if (self.drawer.homeViewController!.view.frame.origin.x == 0) {
                WSDrawerViewController.shared.rightViewController?.view.isHidden = true
                drawerRatio = self.drawerWidth
                touchEnable = false;
                currentDragState = .leftClose
            }
            else {
                drawerRatio = 0;
                touchEnable = true
            }
        }
        else {
            if self.rightViewController != nil {
                if (!isDrawerOpen && self.drawer.rightViewController!.responds(to: #selector(self.viewWillAppear(_:)))) {
                    self.drawer.rightViewController?.viewWillAppear(true)
                }
                
                if (self.drawer.homeViewController!.view.frame.origin.x == 0) {
                    WSDrawerViewController.shared.rightViewController?.view.isHidden = false
                    drawerRatio = -self.drawerWidth
                    touchEnable = false;
                    currentDragState = .rightClose
                }
                else {
                    drawerRatio = 0;
                    touchEnable = true
                }
            }
            else {
                touchEnable = true
            }
        }
        
        self.doSlideAnimation(xVariation: drawerRatio, isEnableInteraction: touchEnable)
    }
    
    private func configureController(controller: UIViewController){
        self.addChild(controller)
        controller.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    private func configureDrawerWidth(){
        if (self.homeViewController!.view.frame.size.width < self.homeViewController!.view.frame.size.height) {
            self.drawerWidth = self.homeViewController!.view.frame.size.width / 2 + 50
        }
        else{
            self.drawerWidth = self.homeViewController!.view.frame.size.height / 2 + 50
        }
    }
    
    @objc private func handlePanGesture(pan: UIPanGestureRecognizer){
        
        let touchPoint = pan.location(in: pan.view)
        let velocity = pan.velocity(in: pan.view)
        
        if !WSDrawerViewController.shared.isPanEnabled {
            return
        }
        
        if pan.state == .began {
            touchStartPoint = touchPoint
            touchHoldPoint = touchPoint
            viewStartDragPoint = pan.view?.frame.origin.x ?? 0.0
        }
        else if pan.state == .changed {
            
            touchEndPoint = touchPoint
            let dx = touchEndPoint.x - touchStartPoint.x
            let dy = touchEndPoint.y - touchStartPoint.y
            
            if (dx > 0 && viewStartDragPoint==0 && self.homeViewController!.view.frame.origin.x >= 0) {
                
                guard WSDrawerViewController.shared.drawerMode == .left || WSDrawerViewController.shared.drawerMode == .all else {
                    return
                }
                WSDrawerViewController.shared.rightViewController?.view.isHidden = true
                currentDragState = .leftOpen
            }
            else if(dx < 0 && viewStartDragPoint == 0 && self.homeViewController!.view.frame.origin.x <= 0) {
                
                guard WSDrawerViewController.shared.drawerMode == .right || WSDrawerViewController.shared.drawerMode == .all else {
                    return
                }
                WSDrawerViewController.shared.rightViewController?.view.isHidden = false
                currentDragState = .rightOpen
            }
            else if (dx<0 && viewStartDragPoint == self.drawerWidth){
                
                guard WSDrawerViewController.shared.drawerMode == .left || WSDrawerViewController.shared.drawerMode == .all else {
                    return
                }
                WSDrawerViewController.shared.rightViewController?.view.isHidden = true
                currentDragState = .leftClose
            }
            else if (dx>0 && viewStartDragPoint == (-self.drawerWidth)){
                
                guard WSDrawerViewController.shared.drawerMode == .right || WSDrawerViewController.shared.drawerMode == .all else {
                    return
                }
                WSDrawerViewController.shared.rightViewController?.view.isHidden = false
                currentDragState = .rightClose
            }
            
            self.dragDrawerWithVelocity(velocity: CGPoint(x: dx, y: dy), touchPoint: touchEndPoint)
        }
        else {
            
            if (currentDragState == .leftOpen || currentDragState == .leftClose) {
                if (velocity.x > 350 && viewStartDragPoint > 0) {
                    self.doSlideAnimation(xVariation: WSDrawerViewController.shared.drawerWidth, isEnableInteraction: false)
                }
                else if (velocity.x < -350){
                    self.doSlideAnimation(xVariation: UIScreen.main.bounds.origin.x, isEnableInteraction: true)
                }
                else {
                    self.runDragAnimation()
                }
            }
            else {
                
                if (self.isRightView) {
                    if (velocity.x < -350) {
                        self.doSlideAnimation(xVariation: (-WSDrawerViewController.shared.drawerWidth), isEnableInteraction: false)
                    }
                    else if (velocity.x > 350){
                        self.doSlideAnimation(xVariation: UIScreen.main.bounds.origin.x, isEnableInteraction: true)
                    }
                    else {
                        self.runDragAnimation()
                    }
                }
            }
        }
        
    }
    
    @objc private func handleTapGesture(tap: UIPanGestureRecognizer){
        isClosing = true
        self.runDragAnimation()
    }
    
    private func dragDrawerWithVelocity(velocity: CGPoint, touchPoint: CGPoint) {
        
        if (currentDragState == .leftOpen || currentDragState == .leftClose) {
            if (velocity.x > 0) {
                isClosing = false
                WSDrawerViewController.shared.rightViewController?.view.isHidden = true
            }
            else {
                isClosing = true
            }
            
            if (velocity.x > 0 && (WSDrawerViewController.shared.homeViewController!.view.frame.origin.x + velocity.x) <= WSDrawerViewController.shared.drawerWidth) {
                WSDrawerViewController.shared.homeViewController?.view.frame = CGRect(x: WSDrawerViewController.shared.homeViewController!.view.frame.origin.x + velocity.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }
            else{
                if ((WSDrawerViewController.shared.homeViewController!.view.frame.origin.x + velocity.x) > 0 && (WSDrawerViewController.shared.homeViewController!.view.frame.origin.x + velocity.x) <= WSDrawerViewController.shared.drawerWidth) {
                    WSDrawerViewController.shared.homeViewController?.view.frame = CGRect(x: WSDrawerViewController.shared.homeViewController!.view.frame.origin.x + velocity.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
                }
            }
            
        }
        else {
            if self.isRightView {
                if (velocity.x > 0) {
                    isClosing = true;
                }
                else{
                    isClosing = false
                    WSDrawerViewController.shared.rightViewController?.view.isHidden = false
                }
                if (velocity.x < 0 && (WSDrawerViewController.shared.homeViewController!.view.frame.origin.x + velocity.x) >= (-WSDrawerViewController.shared.drawerWidth)) {
                    WSDrawerViewController.shared.homeViewController?.view.frame = CGRect(x: WSDrawerViewController.shared.homeViewController!.view.frame.origin.x + velocity.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
                }
                else {
                    if ((WSDrawerViewController.shared.homeViewController!.view.frame.origin.x + velocity.x) < 0 && (WSDrawerViewController.shared.homeViewController!.view.frame.origin.x + velocity.x) >= (-WSDrawerViewController.shared.drawerWidth)) {
                        WSDrawerViewController.shared.homeViewController?.view.frame = CGRect(x: WSDrawerViewController.shared.homeViewController!.view.frame.origin.x + velocity.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
                    }
                }
            }
        }
    }
    
    private func runDragAnimation(){
        if (currentDragState == .leftOpen || currentDragState == .leftClose) {
            if (WSDrawerViewController.shared.homeViewController!.view.frame.origin.x > WSDrawerViewController.shared.drawerWidth / 4) {
                if !isClosing {
                    if (self.leftViewController != nil) {
                        if (self.drawer.leftViewController!.responds(to: #selector(self.viewWillAppear(_:)))) {
                            self.drawer.leftViewController?.viewWillAppear(true)
                        }
                    }
                    self.doSlideAnimation(xVariation: WSDrawerViewController.shared.drawerWidth, isEnableInteraction: false)
                }
                else{
                    self.doSlideAnimation(xVariation: UIScreen.main.bounds.origin.x, isEnableInteraction: true)
                }
            }
            else{
                self.doSlideAnimation(xVariation: UIScreen.main.bounds.origin.x, isEnableInteraction: true)
            }
        }
        else {
            if (WSDrawerViewController.shared.homeViewController!.view.frame.origin.x < (-WSDrawerViewController.shared.drawerWidth/4)) {
                if !isClosing {
                    if (self.rightViewController != nil) {
                        if (self.drawer.rightViewController!.responds(to: #selector(self.viewWillAppear(_:)))) {
                            self.drawer.rightViewController?.viewWillAppear(true)
                        }
                    }
                    self.doSlideAnimation(xVariation: -WSDrawerViewController.shared.drawerWidth, isEnableInteraction: false)
                }
                else {
                    self.doSlideAnimation(xVariation: UIScreen.main.bounds.origin.x, isEnableInteraction: true)
                }
            }
            else {
                self.doSlideAnimation(xVariation: UIScreen.main.bounds.origin.x, isEnableInteraction: true)
            }
        }
    }
    
    private func doSlideAnimation(xVariation: CGFloat, isEnableInteraction: Bool){
        UIView.animate(withDuration: 0.2) {
            WSDrawerViewController.shared.homeViewController?.view.frame = CGRect(x: xVariation, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        } completion: { completed in
            WSDrawerViewController.shared.homeViewController?.view.subviews.forEach({ view in
                view.isUserInteractionEnabled = isEnableInteraction
            })
        }
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if (size.width<size.height) {
//            drawerSize
            self.drawerWidth = size.width / 2 + 50;
        }
        else{
//            drawerSize
            self.drawerWidth = size.height / 2 + 50;
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UIViewController {
    public var drawer: WSDrawerViewController {
        WSDrawerViewController.shared
    }
}
