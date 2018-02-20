//
//  PTTextField.swift
//  ParentTown
//
//  Created by Mukesh on 15/01/18.
//  Copyright © 2018 Tickled Media. All rights reserved.
//

import UIKit

@IBDesignable
class PTTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    lazy var helperLbl : UILabel = {
       
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 18))
        label.text  = "TagLine"
        label.font = self.font
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
            updateHelperFont()
        }
    }
    
    @IBInspectable var helperFont: CGFloat = 11 {
        
        didSet {
            updateHelperFont()
        }
    }
    
    @IBInspectable var helperLblColor: UIColor = .black {
        
        didSet {
            updateHelperFont()
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
        addSubview(helperLbl)
    
        
    }
    
    override func didMoveToSuperview() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateHelperFont(){
        helperLbl.text = helperText
        helperLbl.font =  UIFont.systemFont(ofSize: helperFont)//UIFont(name : CustomFont.medium.rawValue, size : helperFont)
        helperLbl.textColor = helperLblColor
    }
    

    
    
    
    func updateLeftView() {
        
        if let image = leftImage {
            
            leftViewMode = UITextFieldViewMode.always
            leftImgView.image = image
            leftImgView.tintColor = helperLblColor
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
            rightImgView.tintColor = helperLblColor
            rightView = rightImgView
            
        } else {
            rightViewMode = UITextFieldViewMode.never
            rightView = nil
        }
        
        
    }
    
    @objc open func textFieldDidBeginEditing() {
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
    }
    
    
    @objc open func textFieldDidEndEditing() {
        activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
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
//        print(borderActiveColor)
    }
    
    

}



extension String {
    /**
     true if self contains characters.
     */
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
