//
//  AVPlayerView.swift
//  Movin_ios
//
//  Created by leznupar999 on 2015/06/03.
//  Copyright (c) 2015 leznupar999. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView: UIView {
    
    var player: AVPlayer! {
        get {
            let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
            return layer.player
        }
        set(newValue) {
            let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
            layer.player = newValue
        }
    }
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    func setVideoFillMode(mode: String) {
        let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
        layer.videoGravity = mode
    }
    
}
