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
    var indexPathes: [IndexPath] = []
    var swipeActionIndexPath: IndexPath? = nil
    
    let hud: JGProgressHUD = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        DataManager.shared.delegate = self
        title = "Containers"
        
        fillContainers()
        self.tableView.reloadData()
    }
    
    private func fillContainers() {
        showHUDWithLoading()
        DataManager.shared.getAllContainers()
    }
    
    private func showHUDWithError(_ text: String = "Error", timeInterval: Double = 1.5) {
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.textLabel.text = text
        hud.show(in: self.tableView)
        hud.dismiss(afterDelay: timeInterval)
    }
    
    private func showHUDWithLoading(_ text: String = "Loading") {
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.textLabel.text = text
        hud.show(in: self.tableView)
    }
    
    private func showHUDWithSuccess(_ text: String = "Success", timeInterval: Double = 1.5) {
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.textLabel.text = text
        hud.show(in: self.tableView)
        hud.dismiss(afterDelay: timeInterval)
    }
    
    private func dismissHUD() {
        hud.dismiss()
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
        indexPathes.append(indexPath)

        return cell
    }
    
    private func createContextualActionWith(_ action: ContainerAction, imageName: String, color: UIColor, indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil, handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.showHUDWithLoading()
            self.containers[indexPath.row].make(action: .pause)
            self.swipeActionIndexPath = indexPath
            success(true)
        })
        
        action.image = UIImage(named: imageName)
        action.backgroundColor = color
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pauseAction = createContextualActionWith(.pause, imageName: "Pause", color: .appleYellow, indexPath: indexPath)
        let startAction = createContextualActionWith(.start, imageName: "Start", color: .appleGreen, indexPath: indexPath)
        let stopAction = createContextualActionWith(.stop, imageName: "Stop", color: .appleRed, indexPath: indexPath)
        let deleteAction = createContextualActionWith(.stop, imageName: "Delete", color: .appleRed, indexPath: indexPath)
        let restartAction = createContextualActionWith(.restart, imageName: "Restart", color: .appleYellow, indexPath: indexPath)
        
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
        self.refreshControl?.endRefreshing()
        dismissHUD()
    }
    
    func resultOfContainerActionWith(_ id: String, _ action: ContainerAction, isError: Bool) {
        if isError {
            showHUDWithError()
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
                
                showHUDWithSuccess()
                
                break
            }
        }
    }
}
