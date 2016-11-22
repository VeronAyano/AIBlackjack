//
//  OrderSelectViewController.swift
//  proyectoFinal
//
//  Created by Vicente Reyes on 11/21/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class OrderSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var orderPicker: UIPickerView!
    var heuristic = 0
    let orders = ["Player First", "AI First"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        orderPicker.dataSource = self
        orderPicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Picker Data Source Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orders.count
    }
    
    // MARK: Picker Delegate Methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return orders[row];
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let destination = segue.destination as! vsCPUViewController
        // Pass the selected object to the new view controller.
        destination.estado.heuristic = self.heuristic
        let index = orderPicker.selectedRow(inComponent: 0)
        if index == 0 {
            destination.estado.turn = false
        }
        else{
            destination.estado.turn = true
        }
    }
    

}
