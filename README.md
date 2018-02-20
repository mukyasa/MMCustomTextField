# How to create a Custom UITextField

**Quote**

We all have one common screen in our app, Login screen or Signup screen where we ask user to add their info in **Textfield**

As this is our first screen of our app, We do our best to give our best first impression, by creating nice animated, clean textfield to suit our needs.

Usually  there are tons of library you can find, But ever wondered how we can make our own custom textfield with our custom needs.

So let's create our first  custom textfield.
//image


We will create a simple Single View Application Project.
//image

Let create a file name CustomTextField which subclass `UITextfield` , We will do all customisation of our TextField's in this class.



    @IBDesignable
    class CustomTextField: UITextField {


        // Only override draw() if you perform custom drawing.
        // An empty implementation adversely affects performance during animation.
        override func draw(_ rect: CGRect) {
            // Drawing code
        }


    }

We will use `IBDesignable` for some properties of TextField so that we can change them in `UIStoryBoard` file.

Now Let  add a TextField in Viewcontroller file  and subclass this TextField to our  `CustomTextField`

First we will create our Placeholder Label so that we can animate it while editing.

    lazy var placeholderLbl : UILabel = {

        let label = UILabel()//UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 18))
        return label

    }()

Now we will give it frame in `drawRect` method exact with textfield frame and add it in out Textfield.

**Note: ** We have to make our inbuilt property `placeholder = ""` so that it doesn't overlap with our custom  `placeholderLbl`

     override func draw(_ rect: CGRect) {
            addSubview(placeholderLbl)
            placeholder = ""
            placeholderLbl.frame = CGRect(x: leftPadding, y: self.bounds.origin.y, width: self.bounds.width, height: self.bounds.height)
        }

The result will be (We have given Full Name as placeholder)
//image

Now let animate this `placeholderLbl` when user taps on textfield.

To do that we have to monitor the event when users taps on it i.e Begin editing (`UITextFieldTextDidBeginEditing`) and End editing (`UITextFieldTextDidEndEditing`)

We will `NotificationCenter` to monitor this events.

     override func didMoveToSuperview() {

            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        }

        deinit {

            NotificationCenter.default.removeObserver(self)
        }


OK, now as we have setup the notification let's write the implementation of `textFieldDidBeginEditing` and `textFieldDidEndEditing`

    //Notification methods
       @objc open func textFieldDidBeginEditing() {
            updatePlaceholder(editBool: true)
        }


        @objc open func textFieldDidEndEditing() {
            updatePlaceholder(editBool: false)
        }

    //Updates the frame of placeholder
       func updatePlaceholder(editBool : Bool){
        print(self.frame)
        if(editBool){

            UIView.animate(withDuration: 0.3, animations: {
                self.placeholderLbl.frame = CGRect(x: self.leftPadding, y: 0, width: self.frame.width, height: 18)
                self.updateHelperFont(editBool: editBool)
            })


        }else{

            UIView.animate(withDuration: 0.3, animations: {
                self.placeholderLbl.frame = CGRect(x: self.leftPadding, y: self.bounds.origin.y, width: self.frame.width, height: self.frame.height)
                self.updateHelperFont(editBool: editBool)

            })


        }
    }
    //Updates the font of placeholder

    func updateHelperFont(editBool : Bool){
        placeholderLbl.text = helperText
        placeholderLbl.font =  UIFont.systemFont(ofSize: editBool ? helperFont/2 : helperFont)
        placeholderLbl.textColor = placeholderLblColor
    }


Ok, Now that's lot of code we have written, Let's break it

We have two important func here `updateHelperFont` and `updatePlaceholder` these two function does very simple job of animating view i.e frame changes when editing and when user return or end's editing.

The result of this code is
//image

Now if you look to result we have sucessfully achieved animating the frame while editing, But there is slight UI issue, It needs some padding on **left** and **top**

To add padding we will create two `IBInspectable` which will help us to add padding through storyboard, Default value is zero.

    @IBInspectable var leftPadding: CGFloat = 0

    @IBInspectable var upperPadding: CGFloat = 0


Now to add padding on real time we will use to in built functions which will add Padding `textRect(forBounds bounds: CGRect)` and `editingRect(forBounds bounds: CGRect)`

The code is

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


The result is below,
//image

Now it looks with some extra spacing. In this way you created floating label type TextField. So easy right : )

Now lets make this textfield more intutive, lets add the border highlight when it user taps and return.

To achieve this we will add two `UIColor` properties  and `CALayer` which will detect the begin editing and end editing, with respect to their event we will update the color of this border.

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

We will use `updateBorder` func and `rectForBorder`  to update the color

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



The above code give frame to layer and color when this events get fired `UITextFieldTextDidBeginEditing` and `UITextFieldTextDidEndEditing`. The updated code for `textFieldDidBeginEditing` and `textFieldDidEndEditing`


    @objc open func textFieldDidBeginEditing() {
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
        updatePlaceholder(editBool: true)

    }


    @objc open func textFieldDidEndEditing() {
        activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
        updatePlaceholder(editBool: false)

    }


The result with above code is, (I changed the background color of view to see clear results)
//image


Let add the left image to Textfield to make it look good, We will add the `leftImage` and write `updateLeftView` func to update the left Image in `UIStoryboard`

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftView()
        }
    }

      func updateLeftView() {

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

So today we learned to create Floating label Textfield, Check the sample for more customsation like adding Left and Right Image
