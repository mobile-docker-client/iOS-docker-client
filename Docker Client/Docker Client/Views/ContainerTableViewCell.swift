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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fill(with model: Container) {
        nameLabel.text = model.name
        drawStatusCircle(with: model.status)
    }

    private func drawStatusCircle(with status: ContainerStatus) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: statusView.frame.width / 2, y: statusView.frame.height / 2), radius: CGFloat(6),
                                      startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        switch status {
        case .run:
            shapeLayer.fillColor = UIColor.appleGreen.cgColor
        case .pause:
            shapeLayer.fillColor = UIColor.appleYellow.cgColor
        case .stop:
            shapeLayer.fillColor = UIColor.appleRed.cgColor
        }
        
        statusView.layer.addSublayer(shapeLayer)
    }
}
