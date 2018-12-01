import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    private var crocodile: SKSpriteNode!
    private var prize: SKSpriteNode!
    
    private var sliceSoundAction: SKAction!
    private var splashSoundAction: SKAction!
    private var nomNomSoundAction: SKAction!
    
    private var levelOver = false
    private var vineCut = false
    
    override func didMove(to view: SKView) {
        setUpPhysics()
        setUpScenery()
        setUpPrize()
        setUpVines()
        setUpCrocodile()
        setUpAudio()
    }
    
    //MARK: - Level setup
    
    fileprivate func setUpPhysics() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        physicsWorld.speed = 1.0
    }
    
    fileprivate func setUpScenery() {
        let background:SKSpriteNode = SKSpriteNode(imageNamed: ImageName.Background)
        background.position = CGPoint(x: 0,y: 0)
        background.anchorPoint = CGPoint(x: 0,y: 0)
        background.zPosition = Layer.Background
        background.size = self.size
        addChild(background)
        
        let water:SKSpriteNode = SKSpriteNode(imageNamed: ImageName.Water)
        water.position = background.position
        water.anchorPoint = background.anchorPoint
        water.zPosition = Layer.Water
        water.size.width = self.size.width
        water.size.height = self.size.height / 100 * 21.39
        addChild(water)
    }
    
    fileprivate func setUpPrize() {
        prize = SKSpriteNode(imageNamed: ImageName.Prize)
        prize.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: ImageName.PrizeMask), size: prize.size)
        prize.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        prize.zPosition = Layer.Prize
        prize.physicsBody!.usesPreciseCollisionDetection = true
        prize.physicsBody!.collisionBitMask = 0
        prize.physicsBody!.categoryBitMask = PhysicsCategory.Prize
        prize.physicsBody!.contactTestBitMask = PhysicsCategory.Crocodile
        prize.physicsBody!.density = 1
        prize.physicsBody!.isDynamic = true
        addChild(prize)
    }
    
    //MARK: - Vine methods
    
    fileprivate func setUpVines() {
        // 1 load vine data
        let dataFile = Bundle.main.path(forResource: GameConfiguration.VineDataFile, ofType: nil)
        let vines = NSArray(contentsOfFile: dataFile!) as! [NSDictionary]
        
        // 2 add vines
        for i in 0..<vines.count {
            // 3 create vine
            let vineData = vines[i]
            let length = Int(truncating: vineData["length"] as! NSNumber)
            let relAnchorPoint = NSCoder.cgPoint(for: vineData["relAnchorPoint"] as! String)
            let anchorPoint = CGPoint(x: relAnchorPoint.x * size.width,
                                      y: relAnchorPoint.y * size.height)
            let vine = VineNode(length: length, anchorPoint: anchorPoint, name: "\(i)")
            
            // 4 add to scene
            vine.addToScene(self)
            
            // 5 connect the other end of the vine to the prize
            vine.attachToPrize(prize)
        }
    }
    
    //MARK: - Croc methods
    
    fileprivate func setUpCrocodile() {
        crocodile = SKSpriteNode(imageNamed: ImageName.CrocMouthClosed)
        crocodile.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: ImageName.CrocMask), size: crocodile.size)
        crocodile.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.312)
        crocodile.zPosition = Layer.Crocodile
        crocodile.physicsBody!.usesPreciseCollisionDetection = true
        crocodile.physicsBody!.collisionBitMask = 0
        crocodile.physicsBody!.categoryBitMask = PhysicsCategory.Crocodile
        crocodile.physicsBody!.contactTestBitMask = PhysicsCategory.Prize
        crocodile.physicsBody!.isDynamic = false
        addChild(crocodile)
        animateCrocodile()
    }
    
    fileprivate func animateCrocodile() {
        let durationOpen = drand48() + 2    //random double in the range 2 to 3
        let open: SKAction = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthOpen))
        let waitOpen: SKAction = SKAction()
        waitOpen.duration = durationOpen
        
        let durationClosed = drand48() * 2 + 3 //random double in the range 3 to 5
        let close: SKAction = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthClosed))
        let waitClosed: SKAction = SKAction()
        waitClosed.duration = durationClosed
        
        let sequence: SKAction = SKAction.sequence([waitOpen, open, waitClosed, close])
        let loop: SKAction = SKAction.repeatForever(sequence)
        crocodile.run(loop)
        
    }
    
    fileprivate func runNomNomAnimationWithDelay(_ delay: TimeInterval) {
        crocodile.removeAllActions()
        
        let closeMouth = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthClosed))
        let wait = SKAction.wait(forDuration: delay)
        let openMouth = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthOpen))
        let sequence = SKAction.sequence([closeMouth, wait, openMouth, wait, closeMouth])
        
        crocodile.run(sequence)
        levelOver = true
    }
    
    //MARK: - Touch handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        vineCut = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let startPoint = touch.location(in: self)
            let endPoint = touch.previousLocation(in: self)
            
            // check if vine cut
            scene?.physicsWorld.enumerateBodies(alongRayStart: startPoint, end: endPoint,
                                                using: { (body, point, normal, stop) in
                                                    self.checkIfVineCutWithBody(body)
            })
            
            // produce some nice particles
            showMoveParticles(touchPosition: startPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    fileprivate func showMoveParticles(touchPosition: CGPoint) { }
    
    //MARK: - Game logic
    
    override func update(_ currentTime: TimeInterval) {
        if levelOver { return }
        
        if prize.position.y <= 0 {
            if(!levelOver){
                run(splashSoundAction)
            }
            switchToNewGameWithTransition(SKTransition.fade(withDuration: 1.0))
            levelOver = true
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if levelOver { return }
        
        if (contact.bodyA.node == crocodile && contact.bodyB.node == prize)
            || (contact.bodyA.node == prize && contact.bodyB.node == crocodile) {
            
            // shrink the pineapple away
            let shrink = SKAction.scale(to: 0, duration: 0.08)
            runNomNomAnimationWithDelay(0.15)
            run(nomNomSoundAction)
            // transition to next level
            switchToNewGameWithTransition(SKTransition.doorway(withDuration: 1.0))
            let removeNode = SKAction.removeFromParent()
            let sequence = SKAction.sequence([shrink, removeNode])
            prize.run(sequence)
        }
    }
    
    fileprivate func checkIfVineCutWithBody(_ body: SKPhysicsBody) {
        if vineCut && !GameConfiguration.CanCutMultipleVinesAtOnce {
            return
        }
        
        let node = body.node!
        
        // if it has a name it must be a vine node
        if let name = node.name {
            run(sliceSoundAction)
            // snip the vine
            node.removeFromParent()
            
            // fade out all nodes matching name
            enumerateChildNodes(withName: name, using: { (node, stop) in
                let fadeAway = SKAction.fadeOut(withDuration: 0.25)
                let removeNode = SKAction.removeFromParent()
                let sequence = SKAction.sequence([fadeAway, removeNode])
                node.run(sequence)
            })
            
            crocodile.removeAllActions()
            crocodile.texture = SKTexture(imageNamed: ImageName.CrocMouthOpen)
            animateCrocodile()
        }
        vineCut = true
    }
    
    fileprivate func switchToNewGameWithTransition(_ transition: SKTransition) {
        let delay = SKAction.wait(forDuration: 1)
        let sceneChange = SKAction.run({
            let scene = GameScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        })
        
        run(SKAction.sequence([delay, sceneChange]))
    }
    
    //MARK: - Audio
    
    fileprivate func setUpAudio() {
        playMusic()
        
        sliceSoundAction = SKAction.playSoundFileNamed(SoundFile.Slice, waitForCompletion: false)
        splashSoundAction = SKAction.playSoundFileNamed(SoundFile.Splash, waitForCompletion: false)
        nomNomSoundAction = SKAction.playSoundFileNamed(SoundFile.NomNom, waitForCompletion: false)
    }
}