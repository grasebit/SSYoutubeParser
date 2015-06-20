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
SSYoutubeParser.h264videosWithYoutubeID("YoutubeID", completionHandler: { (videoDictionary) -> Void in
    let videoSmallURL = videoDictionary["small"]
    let videoMediumURL = videoDictionary["medium"]
    let videoHD720URL = videoDictionary["hd720"]
    
    if let urlStr = videoSmallURL {
        if let playerItem = AVPlayerItem(URL: NSURL(string: urlStr)) {
            let player = AVPlayer(playerItem: playerItem)
        }
    }
})
```

