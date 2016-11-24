//
//  PlayerTableViewController.swift
//  proyectoFinal
//
//  Created by Eliezer Hernandez on 18/11/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit
import CoreData


var players: Array<Player> = []

class PlayerTableViewController: UITableViewController {
    
    var newestPlayers = [Player]()
    
    var initialLength = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
 navigationItem.leftBarButtonItem = editButtonItem
        let moc = CoreDataStack().managedObjectContext
        moc.reset()
        
        
        /*if let savedPlayers = loadPlayers() {
            players += savedPlayers
            for player in players{
                print(player.name)
            }
            for player in savedPlayers{
                print(player.name)
            }
        } else {
        
            loadSamplePlayers()
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let savedPlayers = loadPlayers() {
            players += savedPlayers
        } else {
            
            loadSamplePlayers()
        }
        if initialLength == 0{
            initialLength = players.count
        }
        print(initialLength)
    }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    func loadSamplePlayers(){
        /*let player1 = Player()//name: "Vicente Reyes", lugar: "Torreon", saludos: "Hola a todo mundo")
        player1.name = "Vicente Reyes"
        player1.greeting = "Yo!"
        player1.locationLatitude = 35.709602
        player1.locationLongitude = 139.654939
        let player2 = Player()//name: "Luis Vallejo", lugar: "Gomez Palacio", saludos: "Hola a todo Torreon")
        player2.name = "Luis Vallejo"
        player2.greeting = "Quiubo Vince."
        player2.locationLatitude = 35.625104
        player2.locationLongitude = 139.775525
        let player3 = Player()//name: "Eliezer de la Paz Hdz", lugar: "Lerdo", saludos: "Hola amigos")
        player3.name = "Eliezer de la Paz Hdz"
        player3.greeting = "Hola amigos"
        player3.locationLatitude = 25.517323
        player3.locationLongitude = -103.397642
        
        
        players.append(player1)
        players.append(player2)
        players.append(player3)*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return players.count
        return loadPlayers()!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cellIdentifier = "PlayerTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as! PlayerTableViewCell
        
        //let player = players[indexPath.row]
        let player = loadPlayers()![indexPath.row]
        
        
        cell.PlayerName.text = player.name
        cell.LugarLabel.text = "\(player.locationLatitude), \(player.locationLongitude)"
        cell.SaludosLabel.text = player.greeting


        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let moc = CoreDataStack().managedObjectContext
            /*var delPlayer = players.remove(at: indexPath.row)
            print(delPlayer.managedObjectContext)
            print(CoreDataStack().managedObjectContext)*/
            for player in players{
                print(player.name)
            }
            print(players[indexPath.row].name)
            print(indexPath.row)
            //moc.delete((loadPlayers()?[indexPath.row])!)// as NSManagedObject)
            /*let oToDelete = loadPlayers()?[indexPath.row]
            let newPlayer = Player()
            newPlayer.name = oToDelete?.name
            newPlayer.greeting = oToDelete?.greeting
            newPlayer.locationLatitude = (oToDelete?.locationLatitude)!
            newPlayer.locationLongitude = (oToDelete?.locationLongitude)!
            print(newPlayer.name)
            print(oToDelete?.name)
            moc.delete(newPlayer as NSManagedObject)*/
            /*if let savedPlayers = loadPlayers() {
                moc.delete(savedPlayers[indexPath.row])
            }*/
            let fetchRequest = NSFetchRequest<Player>(entityName: "Player")
            
            // Configure Fetch Request
            fetchRequest.includesPropertyValues = false
            
            do {
                let items = try moc.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
                
                /*for item in items {
                    moc.deleteObject(item)
                }*/
                
                moc.delete(items[indexPath.row])
                
                // Save Changes
                try moc.save()
                
            } catch {
                // Error Handling
                // ...
            }
            print(moc.deletedObjects)
            print(moc)
            do {
                try moc.save()
            } catch {
                print("Failure to save context: \(error)")
            }
            //players.remove(at: indexPath.row)
            players = loadPlayers()!
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let playerDetailViewController = segue.destination as! SecondViewController
            
            // Get the cell that generated this segue.
            if let selectedPlayerCell = sender as? PlayerTableViewCell {
                let indexPath = tableView.indexPath(for: selectedPlayerCell)!
                let selectedPlayer = loadPlayers()![indexPath.row]
                print("AND HIS NAME IS \(selectedPlayer.name)")
                playerDetailViewController.player = selectedPlayer
            }
            
        }
        else if segue.identifier == "AddItem" {
            print("Adding new player.")
            
        }

        
        
        
    }
    @IBAction func unwindToPlayerList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SecondViewController, let player = sourceViewController.player{
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                //players[selectedIndexPath.row] = player
                
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                players = loadPlayers()!
            }else {
            
            // Add a new player.
            //players.append(player)
            //newestPlayers.append(player)
                players = loadPlayers()!
                tableView.reloadData()
                //let newIndexPath = IndexPath(row: loadPlayers()!.count, section: 0)
            //tableView.insertRows(at: [newIndexPath], with: .bottom)
          }
            //savePlayers()
            print("Players in Context:")
            for player in loadPlayers()! {
                print(player.name)
            }
            print("Players in Array:")
            for player in players {
                print(player.name)
            }
            print("Players in Newest:")
            for player in newestPlayers {
                print(player.name)
            }
      }
  }
    // MARK: NSCoding
    func savePlayers() {
        /*let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(players, toFile: Player.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save players...")
        }*/
        let moc = CoreDataStack().managedObjectContext
        /*for player in players {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Player", into: moc) as! Player
        entity.setValue(player.name, forKey: "name")
        entity.setValue(player.greeting, forKey: "greeting")
        entity.setValue(player.locationLatitude, forKey: "locationLatitude")
        entity.setValue(player.locationLongitude, forKey: "locationLongitude")*/
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        //}
        
    }
    
    func loadPlayers() -> [Player]? {
        /*return NSKeyedUnarchiver.unarchiveObject(withFile: Player.ArchiveURL.path) as? [Player]*/
        let moc = CoreDataStack().managedObjectContext
        let fetchRequest = NSFetchRequest<Player>(entityName: "Player")
        var items = [Player]()
        
        do{
            try items = moc.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Player]
        }catch{
            print(error)
        }
        
        for item in items {
            print(item.name)
        }
        
        return items
        
    }
    


}
