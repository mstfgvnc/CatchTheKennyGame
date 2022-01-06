
import UIKit

class ViewController: UIViewController {
    
    //Variables
    var score = 0
    var timer = Timer()
    var counter = 0
    var hideTimer = Timer()
    var highScore = 0
    var kennyPositionX = 0.0
    var kennyPositionY = 0.0
    
    
    //Views
    let timeLabel = UILabel()
    let scoreLabel = UILabel()
    let highScoreLabel = UILabel()
    let kenny = UIImageView()
      
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get Screen Size
        
        let width = view.frame.width
        let height = view.frame.height
        
        // Views properties
        
        scoreLabel.text = "Score: \(score)"
        highScoreLabel.text = "Highscore: \(highScore)"
        highScoreLabel.sizeToFit()
        scoreLabel.sizeToFit()
        timeLabel.frame = CGRect(x: self.view.center.x, y: 50, width: 200, height: 50)
        scoreLabel.frame = CGRect(x: self.view.center.x-(scoreLabel.frame.width/2), y: timeLabel.frame.maxY+30, width:	scoreLabel.frame.width+25, height: 50)
        kenny.frame = CGRect(x: 0, y: scoreLabel.frame.maxY+30, width: width/3, height: (width/3)*1.15)
        kenny.image = UIImage(named: "kenny.png")
        highScoreLabel.frame = CGRect(x: self.view.center.x-(highScoreLabel.frame.width/2), y: kenny.frame.minY+(kenny.frame.height*3)+30, width: highScoreLabel.frame.width+25, height: 50)
        
        view.addSubview(timeLabel)
        view.addSubview(scoreLabel)
        view.addSubview(highScoreLabel)
        view.addSubview(kenny)
        
        
        
        //Highscore check
        
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighScore == nil {
            highScore = 0
            highScoreLabel.text = "Highscore: \(highScore)"
        }
        
        if let newScore = storedHighScore as? Int {
            highScore = newScore
            highScoreLabel.text = "Highscore: \(highScore)"
        }
        
        
        //Images
        kenny.isUserInteractionEnabled = true
       
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
     
        
        kenny.addGestureRecognizer(recognizer)
    
        
      
        //Timers
        counter = 10
        timeLabel.text = String(counter)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(changePositionKenny), userInfo: nil, repeats: true)
        
        changePositionKenny()

        
    }
    
    // Random change position
    
    @objc func changePositionKenny() {
        
        let random = Int(arc4random_uniform(UInt32(9)))
       
        kennyPositionX = kenny.frame.width * Double(random%3)
        kennyPositionY = scoreLabel.frame.maxY + 30.0 + (Double(random/3) * kenny.frame.height)
                
        kenny.frame.origin.x = kennyPositionX
        kenny.frame.origin.y = kennyPositionY
              
        
    }
    
    
    
    @objc func increaseScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    @objc func countDown() {
        
        counter -= 1
        timeLabel.text = String(counter)
        
        if counter == 0 {
            timer.invalidate()
            hideTimer.invalidate()
            /*
            for kenny in kennyArray {
                kenny.isHidden = true
            }
            */
            //HighScore
            
            if self.score > self.highScore {
                self.highScore = self.score
                highScoreLabel.text = "Highscore: \(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highscore")
            }
            
            
            //Alert
            
            let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (UIAlertAction) in
                //replay function
                
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.counter = 10
                self.timeLabel.text = String(self.counter)
                
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.changePositionKenny), userInfo: nil, repeats: true)
            }
            
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        
    }


}
