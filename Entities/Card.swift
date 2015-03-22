
import Foundation
import SpriteKit

/**
    The Card entity that represents the ilustrated images,
    very common in board and card games.
*/
class Card: SKSpriteNode {
    
    /**
        A dictionary with texture images of a card. 
        The indexes below was been supported:
    
        - "front": A pretty image of a card
        - "back": Another side image of a card
    
    */
    var textures = ["front":"back_card.png","back":"back_card.jpg"]
    
    /**
        Define if card shows "front" or "back" texture
        The supported values are:
    
        - true: To face "up" of a card
        - false: To face "down" fo a card
    */
    var faceUp = true
    
    /**
        Define if the drag and drop is enabled into a card
    */
    var draggable = true
    
    /**
        The image element to show for a player when
        the card is not draggable.
    */
    lazy var addedNotDragNode:SKNode? = nil
    
    required init(coder aDecoder: NSCoder){
        
        fatalError("NSCoding not supported")
    }
    
    /**
        Card constructor with some start configurations
    
        :param: imageNamed String name of a front image the card
        :param: labels A dictionary with labels configurations in a card
        :param: options A dictionary with extra options of a card
        :returns: A SKSpriteNode instance that represent a simple card
    */
    init(var imageNamed: String, labels:[[String:Any]]?, options:[String:Any]?) {
        
        var cardTexture = SKTexture(imageNamed: imageNamed)
        
        if let cfgs = options {
            
            if let fUp = cfgs["faceUp"] as? Bool{
                faceUp = fUp
                
                if !faceUp{
                    cardTexture = SKTexture(imageNamed: textures["back"]!)
                    
                    faceUp = true
                }
            }
        }
        
        super.init(texture: cardTexture, color: nil, size: cardTexture.size())
        setTextureOf("front", file: imageNamed)
        
        if let lbls = labels {
            
            for lbl in lbls{
                let label = newLabelWith(lbl)
                addChild(label)
            }
        }
        
        //Enable/Disable drag an drop
        if let cfgs = options{
            
            if let drag = cfgs["drag"] as? Bool{
                
                draggable = drag
            }else{
                draggable = true
            }
        }else{
            draggable = true
        }
        
        userInteractionEnabled = true
    }
    
    /**
        Get texture instance by name. The supported texture names
        are defined on "texture" property.
    
        :param: name The string name of created texture. By default "front" or "back" was supported
        :returns: The SKTexture instance
    */
    func getTextureOf(name:String) -> SKTexture?{
        
        if let textureFile = textures[name]{
            return SKTexture(imageNamed: textures[name]!)
        }else{
        
            return nil
        }
    }
    
    /**
        Set the texture value by name. The supported textures names
        are defined on "texture" property. Additional textures
        can be define in this method.
    
        :param: name The string name of add new texture or change existent one.
        :param: file The string file name/path of a texture
    */
    func setTextureOf(name:String, file:String){
        
        textures[name] = file
    }
    
    /**
        Part of drag and drop feature to a card. This method is trigged
        when the player release a tap in a Card.
    
        :param: touches A NSSet object collection with touches event
        :param: withEvent The UIEvent object
    */
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in touches {
            let pickUp = SKAction.scaleTo(0.35, duration: 0.2)
            
            if touch.tapCount == 2{
                flip()
                
                if !draggable{
                    runAction(pickUp, withKey: "pickup")
                }
            }
            
            if !draggable{
                let notMove = SKTexture(imageNamed: "no-interaction.png")
                
                addedNotDragNode = SKSpriteNode(texture: notMove, color: nil, size: notMove.size())
                addedNotDragNode?.hidden = true
                
                addChild(addedNotDragNode as SKNode!)
            }else{
            
                zPosition = 15
                
                
                runAction(pickUp, withKey: "pickup")
                
            }
            
        }
        
    }
    
    /**
        Part of drag and drop feature to a card. This method is trigged
        when the player is moving a Card into the Scene.
    
        :param: touches A NSSet object collection with touches event
        :param: withEvent The UIEvent object
    */
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        if draggable{
        
            for touch in touches {
                
                let location = touch.locationInNode(scene)
                let touchedNode = nodeAtPoint(location)
                
                touchedNode.position = location
            }
        }else{
            addedNotDragNode?.hidden = false
        }
    }
    
    /**
        Part of drag and drop feature to a card. This method is trigged
        when the player drop a Card.
        
        :param: touches A NSSet object collection with touches event
        :param: withEvent The UIEvent object
    */
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        if draggable{
            
            for touch in touches {
                
                zPosition = 0
                
            }
        }else{
            removeChildrenInArray([addedNotDragNode as SKNode!])
        }
        
        let dropDown = SKAction.scaleTo(0.3, duration: 0.2)
        runAction(dropDown, withKey: "drop")
    }
    
    /**
        The action to called when the player turn the card
        By default, the double taps in a card execute this 
        method and change the "faceUp" property.
    */
    func flip(){
        
        if faceUp {
            texture = getTextureOf("front")
            for child in self.children{
                (child as SKNode).hidden = false
            }
            
            faceUp = false
        }else{
            texture = getTextureOf("back")
            for child in self.children{
                (child as SKNode).hidden = true
            }
            faceUp = true
        }
    }
    
    /**
        Creates a label with configurations define in "options" dictionary param
    
        :param: options The Dicionary in ["property": value] format with attibutes
                        of to a SKLabelNode instance
        :returns: Returns a SKLabelNode instance with a label
    */
    private func newLabelWith(var options:[String:Any]) -> SKLabelNode{
        
        let label = SKLabelNode()
        
        for (propName, propValue) in options {
            
            label[propName] = propValue
        }
        
        return label
    }
}