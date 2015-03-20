
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
                
                if !fUp{
                    cardTexture = SKTexture(imageNamed: textures["back"]!)
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
                
                userInteractionEnabled = drag
            }else{
                userInteractionEnabled = true
            }
        }else{
            userInteractionEnabled = true
        }
        
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
        Creates a label with configurations define in "options" dicionary param
    
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            zPosition = 15
            
            let pickUp = SKAction.scaleTo(0.35, duration: 0.2)
            runAction(pickUp, withKey: "pickup")
            
        }
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        for touch in touches {
            
            let location = touch.locationInNode(scene)
            let touchedNode = nodeAtPoint(location)
            
            touchedNode.position = location
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            
            zPosition = 0
            
            let dropDown = SKAction.scaleTo(0.3, duration: 0.2)
            runAction(dropDown, withKey: "drop")
            
        }
    }
}