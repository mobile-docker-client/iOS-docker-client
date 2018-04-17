//
//  ContainerTableViewCell.swift
//  Docker Client
//
//  Created by Artyom Sheldyaev on 16.03.2018.
//  Copyright © 2018 Artyom Sheldyaev. All rights reserved.
//

import UIKit

class ContainerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fill(with model: Container) {
        nameLabel.text = model.firstName
//        nameLabel.text = model.name
//        statusDescriptionLabel.text = model.statusDescription
//        drawStatusCircle(with: model.status)
    }

    private func drawStatusCircle(with status: ContainerState) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: statusView.frame.width / 2, y: statusView.frame.height / 2), radius: CGFloat(6),
                                      startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        switch status {
        case .running:
            shapeLayer.fillColor = UIColor.appleGreen.cgColor
        case .paused:
            shapeLayer.fillColor = UIColor.appleYellow.cgColor
        case .stopped:
            shapeLayer.fillColor = UIColor.appleRed.cgColor
        case .exited:
            shapeLayer.fillColor = UIColor.black.cgColor
        }
        
        statusView.layer.addSublayer(shapeLayer)
    }
}
