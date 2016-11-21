//
//  PlayerTableViewController.swift
//  proyectoFinal
//
//  Created by Eliezer Hernandez on 18/11/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class PlayerTableViewController: UITableViewController {

    var players = [Player]()
    override func viewDidLoad() {
        super.viewDidLoad()
 navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedPlayers = loadPlayers() {
            players += savedPlayers
        } else {
        
            loadSamplePlayers()
        }
    }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    func loadSamplePlayers(){
        let player1 = Player(name: "Vicente Reyes", lugar: "Torreon", saludos: "Hola a todo mundo")
        let player2 = Player(name: "Luis Vallejo", lugar: "Gomez Palacio", saludos: "Hola a todo Torreon")
        let player3 = Player(name: "Eliezer de la Paz Hdz", lugar: "Lerdo", saludos: "Hola amigos")
        
        players.append(player1!)
        players.append(player2!)
        players.append(player3!)
        
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
        return players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PlayerTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as! PlayerTableViewCell
        
        let player = players[indexPath.row]
        
        cell.PlayerName.text = player.name
        cell.LugarLabel.text = player.lugar
        cell.SaludosLabel.text = player.saludos


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
            players.remove(at: indexPath.row)
            savePlayers()
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
        if segue.identifier == "ShowDetail" {
            let playerDetailViewController = segue.destination as! SecondViewController
            
            // Get the cell that generated this segue.
            if let selectedPlayerCell = sender as? PlayerTableViewCell {
                let indexPath = tableView.indexPath(for: selectedPlayerCell)!
                let selectedPlayer = players[indexPath.row]
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
                players[selectedIndexPath.row] = player
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else {
            
            // Add a new player.
            let newIndexPath = IndexPath(row: players.count, section: 0)
            players.append(player)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
          }
            savePlayers()
      }
  }
    // MARK: NSCoding
    func savePlayers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(players, toFile: Player.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save players...")
        }
    }
    
    func loadPlayers() -> [Player]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Player.ArchiveURL.path) as? [Player]
        
    }
    


}
