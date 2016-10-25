//
//  DragView.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/25.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation

class DragView: UIImageView {
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let touch :UITouch = touches.first!
        let currentPoint : CGPoint = touch.locationInView(self.superview)
        let previousPoint : CGPoint = touch.previousLocationInView(self.superview)
        var center :CGPoint = self.center
        center.x += (currentPoint.x - previousPoint.x);
        center.y += (currentPoint.y - previousPoint.y);
        self.center = center;
    }
    
    
}