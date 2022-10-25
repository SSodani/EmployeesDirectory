//
//  Extentions.swift
//  Employeedirectory
//
//  Created by Sonam Sodani on 2022-10-06.
//

import Foundation
import UIKit

// MARK: - TABLEVIEW Extention

extension UIView {
 
 func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
 var topInset = CGFloat(0)
 var bottomInset = CGFloat(0)
 
 if #available(iOS 11, *), enableInsets {
 let insets = self.safeAreaInsets
 topInset = insets.top
 bottomInset = insets.bottom
 
 print("Top: \(topInset)")
 print("bottom: \(bottomInset)")
 }
 
 translatesAutoresizingMaskIntoConstraints = false
 
 if let top = top {
 self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
 }
 if let left = left {
 self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
 }
 if let right = right {
 rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
 }
 if let bottom = bottom {
 bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
 }
 if height != 0 {
 heightAnchor.constraint(equalToConstant: height).isActive = true
 }
 if width != 0 {
 widthAnchor.constraint(equalToConstant: width).isActive = true
 }
 
 }
}

// MARK: - TABLEVIEW Extention

extension UITableView {
    
    func setEmptyView(title: String) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel:UILabel = {
            let tl = UILabel()
            tl.textColor = UIColor.gray
            tl.font = UIFont.boldSystemFont(ofSize: 16)
            tl.textAlignment = .center
            return tl
        }()
        
        emptyView.addSubview(titleLabel)
        titleLabel.text = title
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.locations = [0.0,1.0]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        let topColor = CGColor(red: 95.0/255.0, green: 165.0/255/0, blue: 1.0, alpha: 1.0)
//        let bottomColor = CGColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0)
//        gradientLayer.frame = self.bounds
//        //constant is for navigationbar. should be setting layer frame in viewcontroller to avoid hard coded value
//        gradientLayer.frame.origin.y += safeAreaInsets.bottom + 50
//        gradientLayer.colors = [topColor,bottomColor]
//        let backgroundView = UIView(frame: self.bounds)
//        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
//        self.backgroundView = backgroundView
//        self.separatorStyle = .singleLine
//        self.backgroundColor = .clear
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        self.backgroundColor = .clear
    }
    
}

