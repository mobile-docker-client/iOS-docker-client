//
//  ContainersTableViewController.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 16.03.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import UIKit
import JGProgressHUD

class ContainersTableViewController: UITableViewController {

    var containers: [Container] = []
    var swipeActionIndexPath: IndexPath? = nil
    
    let hud: JGProgressHUD = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.textLabel.text = "Loading"
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        DataManager.shared.delegate = self
        title = "Containers"
        
        fillContainers()
        self.tableView.reloadData()
    }
    
    private func fillContainers() {
        hud.show(in: self.view)
        DataManager.shared.getAllContainers()
    }

    @objc func refresh() {
        DataManager.shared.getAllContainers()
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
            self.containers[indexPath.row].make(action: .pause)
            self.swipeActionIndexPath = indexPath
            self.hud.show(in: self.view)
            success(true)
        })
        
        pauseAction.image = UIImage(named: "Pause")
        pauseAction.backgroundColor = .appleYellow
        
        let startAction = UIContextualAction(style: .normal, title:  "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.containers[indexPath.row].make(action: .start)
            self.swipeActionIndexPath = indexPath
            self.hud.show(in: self.view)
            success(true)
        })
        
        startAction.image = UIImage(named: "Start")
        startAction.backgroundColor = .appleGreen
        
        let stopAction = UIContextualAction(style: .normal, title:  "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.containers[indexPath.row].make(action: .stop)
            self.swipeActionIndexPath = indexPath
            self.hud.show(in: self.view)
            success(true)
        })
        
        stopAction.image = UIImage(named: "Stop")
        stopAction.backgroundColor = .appleRed
        
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.containers.remove(at: indexPath.row)
            self.swipeActionIndexPath = indexPath
            self.hud.show(in: self.view)
            success(true)
        })
        
        deleteAction.image = UIImage(named: "Delete")
        deleteAction.backgroundColor = .appleRed
        
        let restartAction = UIContextualAction(style: .normal, title:  "Restart", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.containers[indexPath.row].make(action: .restart)
            self.swipeActionIndexPath = indexPath
            self.hud.show(in: self.view)
            success(true)
        })
        
        restartAction.image = UIImage(named: "Restart")
        restartAction.backgroundColor = .appleYellow
        
        if containers[indexPath.row].state == .running {
            return UISwipeActionsConfiguration(actions: [stopAction, pauseAction])
        } else if containers[indexPath.row].state == .paused {
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
}

extension ContainersTableViewController: DataManagerDelegate {
    func allContainersUpdate() {
        self.containers = DataManager.shared.person.containers!
        self.tableView.reloadData()
        self.hud.dismiss()
        self.refreshControl?.endRefreshing()
    }
    
    func resultOfContainerActionWith(_ id: String, _ action: ContainerAction, isError: Bool) {
        if isError {
            hud.textLabel.text = "Error"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        for container in containers {
            if container.id == id {
                switch action {
                case .start:
                    container.set(state: .running)
                case .stop:
                    container.set(state: .stopped)
                case .pause:
                    container.set(state: .paused)
                case .restart:
                    // TODO: Need change state
                    container.set(state: .exited)
                }
                
                self.tableView.reloadRows(at: [swipeActionIndexPath!], with: .automatic)
                
                hud.textLabel.text = "Success"
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 2.0)
                
                break
            }
        }
    }
}
