//
//  CustomTextField.swift
//  MMCustomTextField
//
//  Created by Mukesh on 19/02/18.
//  Copyright © 2018 madabtapps. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    

    
    
    lazy var placeholderLbl : UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    let leftImgView : UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    let rightImgView : UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateRightView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0
    
    @IBInspectable var upperPadding: CGFloat = 0
    
    
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 0.5)
    
    @IBInspectable dynamic open var borderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    
    @IBInspectable dynamic open var borderActiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    
    var placeHolderText : String?
    
    @IBInspectable var helperText : String? {
        
        didSet {
            updateHelperFont(editBool: false)
        }
    }
    
    @IBInspectable var helperFont: CGFloat = 11 {
        
        didSet {
            updateHelperFont(editBool: false)
        }
    }
    
    @IBInspectable var placeholderLblColor: UIColor = .black {
        
        didSet {
            updateHelperFont(editBool: false)
        }
    }
    
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        textRect.origin.y += upperPadding
        
        return textRect
    }
    
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        textRect.origin.y += upperPadding
        return textRect
        
    }
    
    
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x += leftPadding == 0 ? leftPadding : 8
        textRect.origin.y += upperPadding
        return textRect
        
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        var textRect = super.editingRect(forBounds: bounds)
        textRect.origin.x += leftPadding == 0 ? leftPadding : 8
        textRect.origin.y += upperPadding
        return textRect
        
    }
    
    
    override func draw(_ rect: CGRect) {
        
        //prevents to redraw
        guard isFirstResponder == false else { return }
        
        updateBorder()
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLbl)
        placeholder = ""
        
        
    }
    
    override func didMoveToSuperview() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateHelperFont(editBool : Bool){
        placeholderLbl.text = helperText
        placeholderLbl.font =  UIFont.systemFont(ofSize: editBool ? 10 : helperFont)
        placeholderLbl.textColor = placeholderLblColor
    }
    
    
    
    
    
    func updateLeftView() {
        
        placeholderLbl.frame = CGRect(x: leftPadding * 2 + leftImgView.bounds.width, y: self.bounds.origin.y + upperPadding, width: self.bounds.width - leftImgView.bounds.width, height: self.bounds.height)

        if let image = leftImage {
            
            leftViewMode = UITextFieldViewMode.always
            leftImgView.image = image
            leftImgView.tintColor = placeholderLblColor
            leftView = leftImgView

            
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil

        }
        
        
    }
    
    
    func updateRightView() {
        
        if let image = rightImage {
            rightViewMode = UITextFieldViewMode.always
            rightImgView.image = image
            rightImgView.tintColor = placeholderLblColor
            rightView = rightImgView
            
        } else {
            rightViewMode = UITextFieldViewMode.never
            rightView = nil
        }
        
        
    }
    
    func updatePlaceholder(editBool : Bool){
        if(editBool){
            
            UIView.animate(withDuration: 0.3, animations: {
                self.placeholderLbl.frame = CGRect(x: self.leftPadding, y: 0, width: self.frame.width, height: 18)
                self.updateHelperFont(editBool: editBool)
            })
       

        }else{
            
            if(self.text?.count == 0){
                UIView.animate(withDuration: 0.3, animations: {
                    self.placeholderLbl.frame = CGRect(x: self.leftPadding * 2 + self.leftImgView.bounds.width, y: self.bounds.origin.y + self.upperPadding, width: self.bounds.width - self.leftImgView.bounds.width, height: self.bounds.height)

                    self.updateHelperFont(editBool: editBool)
                    
                })
            }
        


        }
    }
    
    @objc open func textFieldDidBeginEditing() {
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
        updatePlaceholder(editBool: true)

    }
    
    
    @objc open func textFieldDidEndEditing() {
        activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
        updatePlaceholder(editBool: false)

    }
    
    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func updateBorder() {
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: true)
        inactiveBorderLayer.backgroundColor = borderInactiveColor?.cgColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: false)
        activeBorderLayer.backgroundColor = borderActiveColor?.cgColor
    }
    
    
    
}
