// Project: YuAlani-HW9
// EID: ay7892
// Course: CS329E
//
//  ViewController.swift
//  YuAlani-HW9
//
//  Created by Alani Yu on 4/15/25.
//

import UIKit

class ViewController: UIViewController {
    
    var queue: DispatchQueue!
    var cellXSize:CGFloat = 0
    var cellYSize: CGFloat = 0
    var safeAreaWidth: CGFloat  = 0
    var safeAreaHeight:  CGFloat  = 0
    var viewBox = UIView()
    var isActive: Bool = true
    var currentDirection: UISwipeGestureRecognizer.Direction!
    var movementStarted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
        safeAreaWidth = safeAreaFrame.width
        safeAreaHeight = safeAreaFrame.height
        
        cellXSize = safeAreaWidth/9
        cellYSize = safeAreaHeight/19
        
        let directions: [UISwipeGestureRecognizer.Direction] = [.left, .right, .up, .down]

        // loops once per each direction to create a gesture recognizer
        for direction in directions {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture))
            swipe.direction = direction
            self.view.addGestureRecognizer(swipe)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recognizeTapGesture))
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
        
        viewBox.backgroundColor = .systemGreen // Pick any color you like
        
        view.addSubview(viewBox)
        
        // makes the view into a square
        viewBox.frame = CGRect(
            x: (safeAreaWidth - cellXSize) / 2,
            y: (safeAreaHeight - cellYSize) / 2,
            width: cellXSize,
            height: cellYSize
        )

        queue = DispatchQueue(label: "myQueue", qos:.utility)
        print("created box")
    }
    
    @IBAction func recognizeTapGesture(recognizer: UITapGestureRecognizer)
    {
        // resets the position and movement of the block
        viewBox.center.x = safeAreaWidth/2
        viewBox.center.y = safeAreaHeight/2
        viewBox.backgroundColor = .systemGreen
        self.isActive = true
        self.movementStarted = false
    }
    
    // checks for a swipe
    @IBAction func recognizeSwipeGesture(recognizer: UISwipeGestureRecognizer)
    {
        guard isActive else { return } // checks if the block has hit a wall

           if !movementStarted {
               // stores the swipe's direction
               currentDirection = recognizer.direction
               movementStarted = true
               viewBox.translatesAutoresizingMaskIntoConstraints = true
               
               queue.async {
                   self.moveBlock()
               }
           } else {
               
               currentDirection = recognizer.direction
           }
    }
    
    func moveBlock() {
        while isActive {
            usleep(300000)

            DispatchQueue.main.sync {
                
                let frame = self.viewBox.frame

                switch self.currentDirection {
                case .left: // ticks left
                    
                    if frame.origin.x / self.cellXSize > 1 {
                        self.viewBox.frame.origin.x -= self.cellXSize
                    } else {
                        self.isActive = false
                    }

                case .right: // ticks right
                    if frame.origin.x / self.cellXSize < 8{
                        self.viewBox.frame.origin.x += self.cellXSize
                    } else {
                        self.isActive = false
                    }

                case .up: // ticks up
                    if frame.origin.y / self.cellYSize > 1 {
                        self.viewBox.frame.origin.y -= self.cellYSize
                    } else {
                        self.isActive = false
                    }

                default: // ticks down
                    if frame.origin.y / self.cellYSize < 18{
                        self.viewBox.frame.origin.y += self.cellYSize
                    } else {
                        self.isActive = false
                    }
                }
            }
        }
        
        // changes the color to red when done
        DispatchQueue.main.sync{
            self.viewBox.backgroundColor = .systemRed
            self.isActive = false
        }
    }
}
