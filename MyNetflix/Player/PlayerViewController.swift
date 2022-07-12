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
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initPlayerUrl()
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
        play()
        showControlView()
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
        guard let playerItem = playerItem else {
            return
        }
        player = AVPlayer(playerItem: playerItem)
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
    func initTimeSlider(){
        timeSlider.tintColor = .red
        DispatchQueue.global(qos: .background).async {
            let duration : CMTime = self.playerItem!.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            DispatchQueue.main.async {
                self.timeSlider.maximumValue = Float(seconds)
            }
        }
        timeSlider.isContinuous = true
        timeSlider.minimumValue = 0
        updateTime(time: .zero)
        remainingTimeLabel.text = convertTimeToString(time: .zero)
        timeSlider.addTarget(self, action: #selector(playbackSliderChagnedValue), for: .valueChanged)
        timeSlider.addTarget(self, action: #selector(playbackSliderEndedTracking),for: [.touchUpInside,.touchUpOutside])
    }
    @objc func playbackSliderEndedTracking(timeSlider: UISlider, event: UIEvent){
        startTimer()
    }
    @objc func playbackSliderChagnedValue(timeSlider: UISlider, event: UIEvent){
        timer?.invalidate()
        DispatchQueue.main.async {
            let seconds = Int64(timeSlider.value * Float(CMTimeScale(NSEC_PER_SEC)))
            let seekTime = CMTimeMake(value: seconds, timescale: CMTimeScale(NSEC_PER_SEC))
            self.player?.seek(to: seekTime)
        }
    }
     
    func addPeriodicTimeObserver(){
        guard let player = player else {
            return
        }
        let timeScale = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: timeScale, queue: .main) { [weak self] currentTime in
//            print(currentTime)
            guard let currentItem = self?.player!.currentItem else{
                print("error")
                return
            }
            guard currentItem.status == .readyToPlay else{
                return
            }
            let totalPlayTime = Float(CMTimeGetSeconds(currentItem.asset.duration))
            let currentPlayTime = Float(CMTimeGetSeconds(currentTime))
            if currentPlayTime == totalPlayTime{
                self?.reset()
                self?.dismiss(animated: false)
            }
            self?.updateTime(time: currentTime)
        }
    }
    func removeTimeObserver(){
        if let token = timeObserverToken{
            player!.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    func updateTime(time: CMTime){
        //totalTime - currentTime
        self.remainingTimeLabel.text = convertTimeToString(time: time)
        timeSlider.value = Float(CMTimeGetSeconds(time))
    }
    func convertTimeToString(time: CMTime) -> String{
        let totalTime = Float(CMTimeGetSeconds(self.playerItem!.asset.duration))
        let currentTime = Float(CMTimeGetSeconds(time))
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
        if player!.isPlaying{
            pause()
        }else{
            play()
        }
    }
    func play(){
        player!.play()
        self.timerNum = 0
        addPeriodicTimeObserver()
        playButton.isSelected = true
    }
    func pause(){
        player!.pause()
        self.timerNum = 0
        removeTimeObserver()
        playButton.isSelected = false
    }
    func reset(){
        player!.pause()
        removeTimeObserver()
        player!.replaceCurrentItem(with: nil)
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
