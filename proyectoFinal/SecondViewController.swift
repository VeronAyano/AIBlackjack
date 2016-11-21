//
//  SecondViewController.swift
//  proyectoFinal
//
//  Created by Vicente Reyes on 11/8/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var player: Player?
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var nameTextField: UITextField!
   
    @IBOutlet var lugarTextField: UITextField!
    
    @IBOutlet var saludosTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        if let player = player {
            navigationItem.title = player.name
            nameTextField.text   = player.name
            lugarTextField.text = player.lugar
            saludosTextField.text = player.saludos
        }
        
        checkValidPlayerName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    func checkValidPlayerName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = textField.text
        checkValidPlayerName()
        navigationItem.title = textField.text
    }
 
    /*  Tengo que checar si puede ejecutar bien esta funcion */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as AnyObject? === saveButton {
//        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let lugar = lugarTextField.text ?? ""
            let saludos = saludosTextField.text ?? ""
            player = Player(name: name, lugar: lugar, saludos: saludos)
            
        }
    }
    /* Checar lo de cancel en Implement Edit and Delete Behavior*/
    @IBAction func cancel(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
        /*let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        } */
    }
    
    
 

}

