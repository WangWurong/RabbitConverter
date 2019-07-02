//
//  ViewController.swift
//  RabbitConverter
//
//  Created by oldFluffyRabbit on 6/30/19.
//  Copyright © 2019 大兔子殿下. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    private let temperatureData = ["°C", "°F"]
    // 1 xx equals yy meters
    private let lengthMap = [
        "inch": 0.0254,
        "foot": 0.3048,
        "yard": 0.9144,
        "mile": 1609.344,
        "m": 1.00,
        "cm": 100.00,
        "mm": 1000.00,
        "km": 0.001
    ]
    
    private let areaMap = [
        ""
    ]

    @IBAction func convertBtn(_ sender: Any) {
        self.view.endEditing(true)
        // get the value from the input
        if let inputVal = Double(inputText.text!) {
            // show the value
            inputDisplay.text = String(inputVal) + (leftButton.titleLabel?.text)! + " is:"
            // loop all the values and convert
            if leftButton.titleLabel?.text == "°C" {
                rightLabel.text = String(format: "%.2f",(9/5) * inputVal + 32) + "°F"
            } else {
                rightLabel.text = String(format: "%.2f",(5/9) * (inputVal - 32)) + "°C"
            }
            // clear the input
            inputText.text = ""
        } else {
            print("error in casting the input value")
        }
    }
    @IBOutlet var inputText: UITextField!
    @IBOutlet var inputDisplay: UILabel!
    @IBOutlet var pickerView: UIPickerView! = UIPickerView()
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var leftButton: UIButton!
    @IBAction func leftButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        pickerView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true
        leftButton.setTitle(temperatureData[0], for: .normal)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return temperatureData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return temperatureData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(temperatureData[row])
        leftButton.setTitle(temperatureData[row], for: .normal)
        pickerView.isHidden = true;
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

