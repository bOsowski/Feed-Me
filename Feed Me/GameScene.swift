import SpriteKit


class GameScene: SKScene {
    
    private var crocodile: SKSpriteNode!
    private var prize: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        //setUpPhysics()
        setUpScenery()
        //setUpPrize()
        //setUpVines()
        setUpCrocodile()
        //setUpAudio()
    }
    
    //MARK: - Level setup
    
    fileprivate func setUpPhysics() { }
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
    
    fileprivate func setUpPrize() { }
    
    //MARK: - Vine methods
    
    fileprivate func setUpVines() { }
    
    //MARK: - Croc methods
    
    fileprivate func setUpCrocodile() {
        crocodile = SKSpriteNode(imageNamed: ImageName.CrocMouthClosed)
        crocodile.physicsBody = SKPhysicsBody()
        crocodile.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.312)
        crocodile.zPosition = Layer.Crocodile
        crocodile.physicsBody?.usesPreciseCollisionDetection = true
        crocodile.physicsBody?.categoryBitMask = 0
        crocodile.physicsBody?.categoryBitMask = PhysicsCategory.Crocodile
        crocodile.physicsBody?.contactTestBitMask = PhysicsCategory.Prize
        crocodile.physicsBody?.isDynamic = false
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
    
    fileprivate func runNomNomAnimationWithDelay(_ delay: TimeInterval) { }
    
    //MARK: - Touch handling
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    fileprivate func showMoveParticles(touchPosition: CGPoint) { }
    
    //MARK: - Game logic
    
    override func update(_ currentTime: TimeInterval) { }
    func didBegin(_ contact: SKPhysicsContact) { }
    fileprivate func checkIfVineCutWithBody(_ body: SKPhysicsBody) { }
    fileprivate func switchToNewGameWithTransition(_ transition: SKTransition) { }
    
    //MARK: - Audio
    
    fileprivate func setUpAudio() { }
}
