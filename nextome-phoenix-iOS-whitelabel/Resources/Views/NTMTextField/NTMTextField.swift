//
//  NTMTextField.swift
//  iosApp
//
//  Created by Anna Labellarte on 16/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import UIKit
@IBDesignable
class NTMTextField: UIView, UITextFieldDelegate {

    @IBInspectable
    var labelResoruce: String = ""
    
    @IBInspectable
    var value: String? = nil{
        didSet{
            if(value == nil){
                valueTextField.text = L10n.settingsDefault
            }else{
                valueTextField.text = value
            }
            handleEditedImage()
        }
    }
    
    //TODO: rename in resource
    @IBInspectable
    var defaultValue: String? = nil
    
    @IBInspectable
    var defaultValueResource: String = ""
    
    @IBInspectable
    var edited: Bool = false
    
    @IBInspectable
    var negativeNumber: Bool = false
    
    @IBInspectable
    var isEnabled: Bool = false{
        didSet{
            setUpEnabledOrDisabled()
        }
    }
    
    @IBOutlet weak var editedImageView: UIImageView!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var labelView: UILabel!
    
    var defaultValueOrResource: String{
        if let defaultValue = defaultValue{
            return defaultValue
        }else{
            return defaultValueResource.localized
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()

    }
    override init(frame: CGRect){
        super.init(frame: frame)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView(){
        let bundle = Bundle.init(for: NTMCheckbox.self)
        if let viewsToAdd = bundle.loadNibNamed("NTMTextField", owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight,
                                            .flexibleWidth]
            labelView.text = labelResoruce.localized
            valueTextField.text = (value == nil) ? defaultValueOrResource : value
            valueTextField.delegate = self
            editedImageView.isHidden = true
            valueTextField.keyboardType = .numberPad
            rightImageView.isHidden = true
            setUpEnabledOrDisabled()
        }
    }
    
    func setUpEnabledOrDisabled(){
        valueTextField.isEnabled = isEnabled
        valueTextField.textColor = isEnabled ? UIColor.label : UIColor.tertiaryLabel

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField.text == defaultValueOrResource && negativeNumber){
            textField.text = "-"
        }else if(textField.text == defaultValueOrResource){
            textField.text = ""
        }
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text == "" || textField.text == "-"){
            value = defaultValueOrResource
            valueTextField.text = defaultValueOrResource
        }else{
            value = textField.text
        }
        handleEditedImage()
        return true
    }
    
   
    
    
    func handleEditedImage(){
        editedImageView.isHidden = (valueTextField.text == defaultValueOrResource)
    }

    
    
    
    
}
