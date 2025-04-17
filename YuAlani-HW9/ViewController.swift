//
//  ViewController.swift
//  YuAlani-HW9
//
//  Created by Alani Yu on 4/15/25.
//

import UIKit

class ViewController: UIViewController {
    
    // the sizes of the cell
    var cellXSize:CGFloat = 0
    var cellYSize: CGFloat = 0
    var safeAreaWidth: CGFloat  = 0
    var safeAreaHeight:  CGFloat  = 0
    var viewBox = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
        safeAreaWidth = safeAreaFrame.width
        safeAreaHeight = safeAreaFrame.height
        
        cellXSize = safeAreaWidth/9
        cellYSize = safeAreaHeight/19
        
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        rightSwipeRecognizer.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipeRecognizer)
        
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        leftSwipeRecognizer.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipeRecognizer)
        
        viewBox.backgroundColor = .systemRed // Pick any color you like
        viewBox.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(viewBox)
        
        print(cellXSize)
        print(cellYSize)
        NSLayoutConstraint.activate([
            viewBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewBox.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewBox.widthAnchor.constraint(equalToConstant: CGFloat(cellXSize)),//CGFloat(horizontalInc)),
            viewBox.heightAnchor.constraint(equalToConstant: CGFloat(cellYSize))//CGFloat(verticalInc))
        ])
        
        print("created box")
    }
    
    @IBAction func recognizeSwipeGesture(recognizer: UISwipeGestureRecognizer)
    {
        if recognizer.state == .ended {
            //boxLabel.text = "Swipe"
            
            //this method allows property changes to an IB-created object with constraints
            viewBox.translatesAutoresizingMaskIntoConstraints = true
            
            //I think it looks nicer without centering first
            //viewBox.center.x = view.center.x
            
            UIView.animate (withDuration: 1.0, animations: {
                self.viewBox.center.x += self.view.bounds.width
            }, completion: { finished in
                self.viewBox.center.x = self.view.center.x - self.view.bounds.width
                UIView.animate (withDuration: 1.0, animations: {
                    self.viewBox.center.x += self.view.bounds.width
                })
            })
        }
        
    }
    
}
