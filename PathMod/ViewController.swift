//
//  ViewController.swift
//  PathMod
//
//  Created by Matt Long on 11/4/15.
//  Copyright © 2015 Matt Long. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var layer:CAShapeLayer!
    
    var points = [CGPoint]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.layer = CAShapeLayer()
        self.layer.bounds = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0)
        self.layer.position = CGPoint(x: 300.0, y: 300.0)
        
        // Generate a starting path that creates a square using
        // 200 points
        var point = CGPoint(x: 0.0, y: 0.0)
        points.append(point)
        
        var i:Int = 0
        repeat {
            point = CGPoint(x: CGFloat(i), y: 0)
            points.append(point)
            i += 10
        } while i < 200

        i = 0
        repeat {
            point = CGPoint(x: 200.0, y: CGFloat(i))
            points.append(point)
            i += 10
        } while i < 200
        
        i = 200
        repeat {
            point = CGPoint(x: CGFloat(i), y: 200.0)
            points.append(point)
            i -= 10
        } while (i > 0)
        
        
        i = 200
        repeat {
            point = CGPoint(x: 0, y: CGFloat(i))
            points.append(point)
            i -= 10
        } while (i > 0)
        
        // Create a path with the array of points
        self.layer.path = points.path
        
        // Set the fill color and stroke color
        self.layer.fillColor = UIColor.orange.cgColor
        self.layer.strokeColor = UIColor.blue.cgColor
        
        self.layer.lineWidth = 4.0
        
        // Add the shape layer to the view
        self.view.layer.addSublayer(self.layer)
    }

    
    @IBAction func didTapAnimate(_ sender:AnyObject) {
        
        // Generate an array of points positioned around a circle that we 
        // conver to a path
        var newPoints = [CGPoint]()

        let r:CGFloat = 200.0
        let x0:CGFloat = 400.0
        let y0:CGFloat = 400.0
        var i:Int = 0
        
        repeat {
            // Little bit of trig to calculate where each point goes
            // evenly spaced around our destination circle.
            let x:CGFloat = x0 + r * cos(CGFloat(2) * CGFloat(M_PI) * CGFloat(i) / CGFloat(self.points.count))
            let y:CGFloat = y0 + r * sin(CGFloat(2) * CGFloat(M_PI) * CGFloat(i) / CGFloat(self.points.count))
            
            newPoints.append(CGPoint(x: x, y: y))
            i += 1
        } while i < self.points.count

        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = newPoints.path // Convert our new points array to a CGPathRef
        
        // Set the animation duration and specify we want it to return to its
        // starting shape.
        animation.duration = 1.0
        animation.autoreverses = true
        
        self.layer.add(animation, forKey: "path")
        
    }

}

protocol Pointable {
    var point:CGPoint { get }
}

extension CGPoint: Pointable {
    var point : CGPoint {
        get {
            return self
        }
    }
}

extension Array where Element : Pointable {
    var path : CGPath {
        let bezier = UIBezierPath()
        
        if self.count > 0 {
            bezier.move(to: self[0].point)
        }
        
        var i:Int = 0
        repeat {
            bezier.addLine(to: self[i].point)
            i += 1
        } while i < self.count
        
        bezier.close()
        
        return bezier.cgPath
        
    }
}
