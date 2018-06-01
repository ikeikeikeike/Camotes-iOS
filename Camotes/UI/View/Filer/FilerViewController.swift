//
//  FilerViewController.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/28.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


let unko = "http://localhost:8000/api/stream/aHR0cHM6Ly93d3cueHZpZGVvcy5jb20vdmlkZW8zNjE1MzEyNy8zMTI2NTg3LzAvc2xpbV9tb21fcG9zaXRpb25zX2hlcl90aWdodF9jdW50X29uX2hhcmRfY29ja193aGlsc3RfZGVlcHRocm9hdGluZw==?format=mp4-low"


class FilerViewController: UIViewController {
    
    let useCase: FilerUseCase! = Injector.ct.resolve(FilerUseCase.self)
    var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func play(_ sender: Any) {
//        guard let id = title else {
//            return showAlert("player failed")
//        }
        
//        let av = useCase.find(id: id)
//        self.title = av?.title
        
        guard let url = URL(string: unko) else {
            return showAlert("player failed")
        }
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        //        let asset = AVURLAsset(url: url)
        let item = CachingPlayerItem(url: url)
        item.delegate = self
        
        player = AVPlayer(playerItem: item)
        player.automaticallyWaitsToMinimizeStalling = false
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            self.player.playImmediately(atRate: 1.0)
        }
    }
}

extension FilerViewController: CachingPlayerItemDelegate {
    
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        print("File is downloaded and ready for storing")
        player.playImmediately(atRate: 1.0)
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
        print("\(bytesDownloaded)/\(bytesExpected)")
    }
    
    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
        print("Not enough data for playback. Probably because of the poor network. Wait a bit and try to play later.")
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        print(error)
    }
}
