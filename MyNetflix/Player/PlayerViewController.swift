//
//  PlayerViewController.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/07/03.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    var timeObserverToken: Any?
    var timerNum = 0
    var timer: Timer?
    let player = AVPlayer()
//    var playerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initPlayerUrl()
        showControlView()
        play()
        initTimeSlider()
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if controlView.alpha == 0{
            showControlView()
        }else if controlView.alpha == 1{
            hideControlView()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    func startTimer(){
        timerNum = 0
        if timer != nil{
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(autoHideControlView), userInfo: nil, repeats: true)
    }
    
    @objc func autoHideControlView(){
//        print(timerNum)
        if timerNum == 3{
            hideControlView()
            timer?.invalidate()
            timer = nil
        }
        timerNum += 1

    }
    func initPlayerUrl(){
        guard let playerItem = player.currentItem else {
            print("is not item")
            return
        }
        print("success get player item : \(playerItem)")
        playerView.player = player
    }

    func hideControlView(){
        UIView.animate(withDuration: 0.4){
            self.controlView.alpha = 0
        }
    }
    func showControlView(){
        UIView.animate(withDuration: 0.4){
            self.controlView.alpha = 1
        }
        startTimer()
    }
//
    func initTimeSlider(){
        timeSlider.tintColor = .red
        timeSlider.isContinuous = true
        timeSlider.minimumValue = 0
//        print("totalTime : \(Float(CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))))")
        timeSlider.value = .zero
        updateTime(time: .zero)
        timeSlider.addTarget(self, action: #selector(playbackSliderChagnedValue), for: .valueChanged)
    }
    

    @objc func playbackSliderChagnedValue(timeSlider: UISlider, event: UIEvent){
        if let touchEvent = event.allTouches?.first {
               switch touchEvent.phase {
               case .began:
                   // handle drag began
                   pause()
                   timer?.invalidate()
                   
               case .moved:
                   // handle drag moved
                   print("moved")
                   //totaltime - slider.value
                   let seconds : Int64 = Int64(timeSlider.value * Float(CMTimeScale(NSEC_PER_SEC)))
                   let targetTime:CMTime = CMTimeMake(value: seconds, timescale: CMTimeScale(NSEC_PER_SEC))
                   self.remainingTimeLabel.text = convertTimeToString(time: targetTime)
               case .ended:
                   // handle drag ended
                   let seconds = Int64(timeSlider.value * Float(CMTimeScale(NSEC_PER_SEC)))
                   let seekTime = CMTimeMake(value: seconds, timescale: CMTimeScale(NSEC_PER_SEC))
                   self.player.seek(to: seekTime)
                   if player.rate == 0{
                       play()
                   }
                   startTimer()
               default:
                   break
               }
           }
    }
     
    func addPeriodicTimeObserver(){
        print("add time obeserver")
        let timeScale = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: timeScale, queue: .main) { [weak self] currentTime in
            
            let totalPlayTime = Float(CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)))
            
            self?.timeSlider.maximumValue = totalPlayTime
            self?.updateTime(time: currentTime)
            
            let currentPlayTime = Float(CMTimeGetSeconds(currentTime))
            if currentPlayTime == totalPlayTime{
                self?.reset()
                self?.dismiss(animated: false)
            }
        }
    }
    func removeTimeObserver(){
        if let token = timeObserverToken{
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    func updateTime(time: CMTime){
        self.remainingTimeLabel.text = convertTimeToString(time: time)
        timeSlider.value = Float(CMTimeGetSeconds(time))
    }
    func convertTimeToString(time: CMTime) -> String{
        let totalTime = Float(CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)))
        let currentTime = Float(CMTimeGetSeconds(time))
        print(currentTime, totalTime)
        guard !totalTime.isInfinite, !totalTime.isNaN, !currentTime.isInfinite, !currentTime.isNaN else{
            print("time is infinite or NaN")
            return String(format: "%02d:%02d", 0, 0)
        }
        //totalTime - currentTime
        let remainingTime = Int(totalTime-currentTime)
        let min = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", min, seconds)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        reset()
        self.dismiss(animated: false)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }
    
    @IBAction func togglePlayButton(_ sender: Any) {
        if player.isPlaying{
            pause()
        }else{
            play()
        }
    }
    func play(){
        player.play()
        self.timerNum = 0
        addPeriodicTimeObserver()
        playButton.isSelected = true
    }
    func pause(){
        player.pause()
        self.timerNum = 0
        removeTimeObserver()
        playButton.isSelected = false
    }
    func reset(){
        player.pause()
        removeTimeObserver()
        player.replaceCurrentItem(with: nil)
    }
}

extension AVPlayer{
    var isPlaying: Bool{
        guard self.currentItem != nil else{
            return false
        }
        return self.rate != 0
    }
}
