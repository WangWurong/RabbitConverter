//
//  ViewController.swift
//  RabbitConverter
//
//  Created by oldFluffyRabbit on 6/30/19.
//  Copyright © 2019 大兔子殿下. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    // ==================== Constents:
    private let temperatureData = ["°F", "°C"]
    
    // Length: 1 xx equals yy meters
    private let lengthMap = [
        "inch": 0.0254,
        "foot": 0.3048,
        "yard": 0.9144,
        "mile": 1609.344,
        "m": 1.00,
        "cm": 0.01,
        "mm": 0.001,
        "km": 1000
    ]
    private let lengthList = ["inch", "foot", "yard", "mile", "m", "cm", "mm", "km"]
    
    // Area: 1 square XX equals yy square meters
    private let areaMap = [
        "sqcm": 0.0001,
        "sqm": 1,
        "sqinch": 0.0006452,
        "sqf": 0.09290,
        "acre": 4047,
        "sqmile": 2590000
    ]
    private let areaList = ["sqcm", "sqm", "sqinch", "sqf", "acre", "sqmile"]
    
    // Volume: to L
    private let volumeMap = [
        "tbsp": 0.015,
        "fl oz": 0.03,
        "cup": 0.237,
        "pint": 0.473,
        "quart": 0.946,
        "gallon": 3.8,
        "ml": 0.001,
        "L": 1
    ]
    private let volumeList = ["tbsp", "fl oz", "cup", "pint", "quart", "gallon", "ml", "L"]
    
    // Weight: to kg
    private let weightMap = [
        "gram": 0.001,
        "kg": 1,
        "ounze oz": 0.02835,
        "pound lb": 0.4536,
        "ton": 1000
    ]
    private let weightList = ["gram", "kg", "ounze oz", "pound lb", "ton"]
    private var dictArray = [[String : Double]]()
    private var listArray = [[String]]()
    
   
    
    // ==================== UI variables:
    // customized segment control
    var activeTabIndex = 0
    @IBOutlet var linerSegmentControl: LinerSegmentControl!
    @IBAction func linerSelectorIndexChanged(_ sender: Any) {
        activeTabIndex = linerSegmentControl.selectedSegmentIndex
        reloadPickerView()
        reloadDisplay()
    }
    
    // UIPickerView
    @IBOutlet var pickerView: UIPickerView! = UIPickerView()
    
    // input and output label area
    @IBOutlet var inputText: UITextField!
    @IBOutlet var resultText: UILabel!
    
    // left and right button to show the unit
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBAction func leftButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        pickerView.isHidden = false
        activeButton = leftButton
        
    }
    @IBAction func rightButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        pickerView.isHidden = false
        activeButton = rightButton
    }
    
    // get the result
    @IBAction func convertClicked(_ sender: Any) {
        self.view.endEditing(true)
        // check the left and right value
        let inputVal = inputText.text
        let leftText = leftButton.titleLabel?.text
        let rightText = rightButton.titleLabel?.text
        if inputVal != nil && leftText != nil && rightText != nil {
            compute(leftText: leftText!, rightText: rightText!, inputVal: Double(inputVal!)!)
            revertButton.isHidden = false
        }
    }
    @IBOutlet var revertButton: UIButton!
    @IBAction func revertClicked(_ sender: Any) {
        // revert the current
        let inputVal = inputText.text
        let leftText = leftButton.titleLabel?.text
        let rightText = rightButton.titleLabel?.text
        // switch the button value
        leftButton.setTitle(rightText, for: .normal)
        rightButton.setTitle(leftText, for: .normal)
        if inputVal != nil && leftText != nil && rightText != nil {
            compute(leftText: rightText!, rightText: leftText!, inputVal: Double(inputVal!)!)
        }
    }

    // ============ System functions:
    override func viewDidLoad() {
        super.viewDidLoad()
    
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true

        dictArray = [lengthMap, areaMap, volumeMap, weightMap]
        listArray = [lengthList, areaList, volumeList, weightList]
        
        reloadPickerView()
        reloadDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ================== UI PickerView Related:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTabIndex == 0 {
            return temperatureData.count
        } else {
            return listArray[activeTabIndex - 1].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTabIndex == 0 {
            return temperatureData[row]
        } else {
            return listArray[activeTabIndex - 1][row]
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeTabIndex == 0 {
            activeButton.setTitle(temperatureData[row], for: .normal)
            pickerView.isHidden = true;
        } else {
            activeButton.setTitle(listArray[activeTabIndex - 1][row], for: .normal)
            pickerView.isHidden = true;
        }
        
    }
    
    private func reloadPickerView() {
        // reload the datasources
        pickerView.reloadAllComponents()
        
        // reload the default value of the left and right button
        if activeTabIndex == 0 {
            leftButton.setTitle(temperatureData[0], for: .normal)
            rightButton.setTitle(temperatureData[1], for: .normal)
        } else {
            leftButton.setTitle(listArray[activeTabIndex - 1][0], for: .normal)
            rightButton.setTitle(listArray[activeTabIndex - 1][1], for: .normal)
        }
    }
    
    // =============== Main Feature Funtion:
    private func compute(leftText: String, rightText: String, inputVal: Double) {
        if activeTabIndex == 0 {
            // temperature
            if leftText == "°C" && rightText == "°F" {
                resultText.text = String(format: "%.2f",(9/5) * inputVal + 32)
            } else if leftText == "°F" && rightText == "°C" {
                resultText.text = String(format: "%.2f",(5/9) * (inputVal - 32))
            } else {
                resultText.text = String(format: "%.2f", inputVal)
            }
        } else {
            // other unit group
            let res = Double((dictArray[activeTabIndex - 1][leftText]! / dictArray[activeTabIndex - 1][rightText]!) * inputVal)
            resultText.text = String(format: "%.2f", res)
        }
    }
    
    // =============== Helper functions:
    private func reloadDisplay() {
        inputText.text = ""
        resultText.text = ""
        revertButton.isHidden = true
    }
    
    // keyboard hide
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

