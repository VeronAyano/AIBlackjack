//
//  SecondViewController.swift
//  proyectoFinal
//
//  Created by Vicente Reyes on 11/8/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class SecondViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var player: Player?
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet weak var locationMap: MKMapView!
    @IBOutlet var saludosTextField: UITextField!
    
    var selectedLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        if let player = player {
            navigationItem.title = player.name
            nameTextField.text   = player.name
            /*lugarTextField.text = player.lugar
            saludosTextField.text = player.saludos*/
            selectedLocation = CLLocation(latitude: player.locationLatitude, longitude: player.locationLongitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedLocation.coordinate
            locationMap.addAnnotation(annotation)
            var region = MKCoordinateRegion()
            region.center = selectedLocation.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
            locationMap.setRegion(region, animated: true)
        }
        
        let isPresentingInAddPlayerMode = presentingViewController is UINavigationController
        if isPresentingInAddPlayerMode {
            nameTextField.isEnabled = false
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
            //let isPresentingInAddPlayerMode = presentingViewController is UINavigationController
            //if !isPresentingInAddPlayerMode {
            //let p = player?.name
            if player == nil{
//        if saveButton === sender {
            let name = nameTextField.text ?? ""
            //let lugar = lugarTextField.text ?? ""
            let saludos = saludosTextField.text ?? ""
            //player = Player(name: name, lugar: lugar, saludos: saludos)
            let moc = CoreDataStack().managedObjectContext
            /*let entity = NSEntityDescription()
            player = Player(entity: entity, insertInto: moc)*/
            let entity = NSEntityDescription.insertNewObject(forEntityName: "Player", into: moc) as! Player
            
            /*player?.name = name
            player?.greeting = saludos
            player?.locationLatitude = selectedLocation.coordinate.latitude
            player?.locationLongitude = selectedLocation.coordinate.longitude
            
            entity.setValue(player?.name, forKey: Player.PropertyKey.nameKey)
            entity.setValue(player?.greeting, forKey: Player.PropertyKey.saludosKey)
            entity.setValue(player?.locationLatitude, forKey: Player.PropertyKey.locLatKey)
            entity.setValue(player?.locationLongitude, forKey: Player.PropertyKey.locLongKey)*/
            entity.setValue(name, forKey: "name")
            entity.setValue(saludos, forKey: "greeting")
            entity.setValue(selectedLocation.coordinate.latitude, forKey: "locationLatitude")
            entity.setValue(selectedLocation.coordinate.longitude, forKey: "locationLongitude")
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            /*let destination = segue.destination as! PlayerTableViewController
            destination.players += [entity]*/
            player = entity
            }
            else{
                //var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
                var context: NSManagedObjectContext = CoreDataStack().managedObjectContext
                
                var fetchRequest = NSFetchRequest<Player>(entityName: "Player")
                fetchRequest.predicate = NSPredicate(format: "name = %@", nameTextField.text!)
                
                var fetchResults = [Player]()
                
                do{
                    try fetchResults = context.fetch(fetchRequest)
                } catch {
                    print("Unable to fetch object")
                }
                
                
                    if fetchResults.count != 0{
                        
                        var managedObject = fetchResults[0]
                        managedObject.setValue(saludosTextField.text, forKey: "greeting")
                        managedObject.setValue(selectedLocation.coordinate.latitude, forKey: "locationLatitude")
                        managedObject.setValue(selectedLocation.coordinate.longitude, forKey: "locationLongitude")
                        do{
                        try context.save()
                        } catch {
                            print("Unable to Save")
                        }
                    }
                
            }
            
        }
    }
    /* Checar lo de cancel en Implement Edit and Delete Behavior*/
    @IBAction func cancel(_ sender: UIBarButtonItem) {
         //self.dismiss(animated: true, completion: nil)
        let isPresentingInAddPlayerMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPlayerMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    @IBAction func selectLocation(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: locationMap)
        let coords = locationMap.convert(location,toCoordinateFrom: locationMap)
        selectedLocation = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        // Add annotation:
        locationMap.removeAnnotations(locationMap.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords
        locationMap.addAnnotation(annotation)
    }
    
 

}

