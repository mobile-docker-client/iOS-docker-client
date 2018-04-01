//
//  ContainersTableViewController.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 16.03.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import UIKit

class ContainersTableViewController: UITableViewController {

    var containers: [Container] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Containers"
        
        fillContainers()
        self.tableView.reloadData()
    }
    
    private func fillContainers() {
        containers.append(Container(id: "1", status: .run, statusDescription: "Up 5 seconds", name: "First"))
        containers.append(Container(id: "2", status: .pause, statusDescription: "Up 2 minutes (Paused)", name: "Second"))
        containers.append(Container(id: "3", status: .stop, statusDescription: "Exited (0) 38 minutes ago", name: "Third"))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "containerCell", for: indexPath) as! ContainerTableViewCell
        
        cell.fill(with: containers[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pauseAction = UIContextualAction(style: .normal, title:  "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.containers[indexPath.row].set(status: .pause)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            success(true)
        })
        
        pauseAction.image = UIImage(named: "Pause")
        pauseAction.backgroundColor = .appleYellow
        
        let startAction = UIContextualAction(style: .normal, title:  "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.containers[indexPath.row].set(status: .run)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            success(true)
        })
        
        startAction.image = UIImage(named: "Start")
        startAction.backgroundColor = .appleGreen
        
        let stopAction = UIContextualAction(style: .normal, title:  "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.containers[indexPath.row].set(status: .stop)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            success(true)
        })
        
        stopAction.image = UIImage(named: "Stop")
        stopAction.backgroundColor = .appleRed
        
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.containers.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            success(true)
        })
        
        deleteAction.image = UIImage(named: "Delete")
        deleteAction.backgroundColor = .appleRed
        
        let restartAction = UIContextualAction(style: .normal, title:  "Restart", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.containers[indexPath.row].set(status: .run)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            success(true)
        })
        
        restartAction.image = UIImage(named: "Restart")
        restartAction.backgroundColor = .appleYellow
        
        if containers[indexPath.row].status == .run {
            return UISwipeActionsConfiguration(actions: [stopAction, pauseAction])
        } else if containers[indexPath.row].status == .pause {
            return UISwipeActionsConfiguration(actions: [deleteAction, restartAction])
        } else {
            return UISwipeActionsConfiguration(actions: [deleteAction, startAction])
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "openContainerSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openContainerSegue" {
            if let destinatonVC = segue.destination as? ContainerViewController, let indexPath = sender as? IndexPath {
                destinatonVC.container = containers[indexPath.row]
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
