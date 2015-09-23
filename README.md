##SSYoutubeParser

Create based on HCYoutubeParser.  
https://github.com/hellozimi/HCYoutubeParser  
Thank you. hellozimi

You can also playback video that can not be played on HCYoutubeParser.  
You can not play video There are some.

HCYoutubeParserを元にSwiftで作成しています。  
HCYoutubeParserで再生できないビデオも再生出来ます。  
一部の再生制限のあるビデオは再生できません。（今後クリアしたい）


```swift
//Swift2.0

func setupVideo() {
    SSYoutubeParser.h264videosWithYoutubeID("b2fjU9cmjXg") { (videoDictionary) -> Void in
        //let videoSmallURL = videoDictionary["small"]
        let videoMediumURL = videoDictionary["medium"]
        //let videoHD720URL = videoDictionary["hd720"]
        
        if let urlStr = videoMediumURL {
            if let playerItem:AVPlayerItem = AVPlayerItem(URL: NSURL(string: urlStr)!) {
                self.avPlayerView.player = AVPlayer(playerItem: playerItem)
                playerItem.addObserver(self, forKeyPath: "status", options: [.New,.Old,.Initial], context: nil)
            }
        }
    }
}

override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if keyPath == "status" {
        let change2 = change!
        let changeOld = change2["old"] as? NSNumber
        let changeNew = change2["new"] as? NSNumber
        let status = object!.status as AVPlayerItemStatus
        
        if changeOld == 0 && changeNew == 1 && status == AVPlayerItemStatus.ReadyToPlay {
            self.avPlayerView.player.play()
        }
    } else {
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
}
```

