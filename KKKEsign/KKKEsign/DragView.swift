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
        let currentP : CGPoint = touch.locationInView(self.superview)
        let preP : CGPoint = touch.previousLocationInView(self.superview)
        var center :CGPoint = self.center
        center.x += (currentP.x - preP.x);
        center.y += (currentP.y - preP.y);
        self.center = center;
    }
    
    
}