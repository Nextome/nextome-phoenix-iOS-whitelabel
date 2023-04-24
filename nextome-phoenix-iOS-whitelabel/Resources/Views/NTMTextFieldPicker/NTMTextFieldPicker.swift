//
//  NTMTextFieldPicker.swift
//  iosApp
//
//  Created by Anna Labellarte on 17/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import UIKit
@IBDesignable
class NTMTextFieldPicker: NTMTextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var options: [String] = []
    private lazy var picker = UIPickerView()
    
    override func initView(){
        super.initView()
        rightImageView.isHidden = false
        setupAccessoryView()
    }
    
    func setOptions(_ options: [String]){
        self.options = options
    }
    
    func setupAccessoryView(){
        picker.delegate = self
        picker.dataSource = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onSelected))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        valueTextField.inputAccessoryView = toolBar
        valueTextField.inputView = picker
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("Row for component \(component)")
        return options[row]
    }
    
    @objc func onSelected(){
        let selectedIndex = picker.selectedRow(inComponent: 0)
        let valueSelected = options[selectedIndex]
        valueTextField.text = valueSelected
        print("\(options[selectedIndex]) \(selectedIndex)")
        if(valueSelected != defaultValue?.localized ){
            value = valueSelected
        }else{
            value = nil
        }
        valueTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        options.count
    }

    
}
